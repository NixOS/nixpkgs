{ stdenv, lib, libarchive, zookeeper_mt, makeWrapper, fetchurl, curl, cyrus_sasl, openssh
, unzip, gnutar, jdk, python, boost165, protobuf3_5, ensureNewerSourcesForZipFilesHook
, apr, subversion, gzip, grpc_1_10, rapidjson, libseccomp, gmock, jemalloc
, leveldb, glog, linuxPackages, utillinux, libnl, iproute, openssl, libevent, libev
, ethtool, coreutils, which, iptables, maven
, bash, autoreconfHook
, utf8proc, lz4
, withJava ? !stdenv.isDarwin
}:

let
  protobuf = protobuf3_5;
  grpc = grpc_1_10.override { inherit protobuf; };

  mavenRepo = import ./mesos-deps.nix { inherit stdenv curl; };
  # `tar -z` requires gzip on $PATH, so wrap tar.
  # At some point, we should try to patch mesos so we add gzip to the PATH when
  # tar is invoked. I think that only needs to be done here:
  #   src/common/command_utils.cpp
  # https://github.com/NixOS/nixpkgs/issues/13783
  tarWithGzip = lib.overrideDerivation gnutar (oldAttrs: {
    # Original builder is bash 4.3.42 from bootstrap tools, too old for makeWrapper.
    builder = "${bash}/bin/bash";
    buildInputs = (oldAttrs.buildInputs or []) ++ [ makeWrapper ];
    postInstall = (oldAttrs.postInstall or "") + ''
      wrapProgram $out/bin/tar --prefix PATH ":" "${gzip}/bin"
    '';
  });

in stdenv.mkDerivation rec {
  version = "1.10.0";
  pname = "mesos";

  enableParallelBuilding = true;
# dontDisableStatic = true;

  src = fetchurl {
    url = "mirror://apache/mesos/${version}/${pname}-${version}.tar.gz";
    sha256 = "188jkvgykisgzcscv0c34x1zlk1sscp9ld2dvx5361grx6hyifgl";
  };

  patches = [
    # https://reviews.apache.org/r/36610/
    # TODO: is this still needed?
    ./rb36610.patch

    # see https://github.com/cstrahan/mesos/tree/nixos-${version}
    ./nixos.patch
  ];
  postPatch = ''
    rm 3rdparty/{boost,protobuf,leveldb,libarchive,glog,grpc,libev,libseccom,rapidjson,googletest,jemalloc}*
  '';

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    ensureNewerSourcesForZipFilesHook
    (python.withPackages (p:
      [ # python deps needed during wheel build time (not runtime, see the buildPythonPackage part for that)
        p.setuptools
        p.boto
        (p.protobuf.override { inherit protobuf; })
    ]))
  ];
  buildInputs = [
    curl cyrus_sasl
    python /*python.pkgs.wrapPython*/ leveldb grpc
    subversion apr glog gmock openssl libevent libev libarchive jemalloc
    utf8proc lz4 protobuf rapidjson boost165
  ] ++ lib.optionals stdenv.isLinux [
    libseccomp
    libnl
  ] ++ lib.optionals withJava [
    jdk maven
  ];

  propagatedBuildInputs = [
    (python.pkgs.protobuf.override { inherit protobuf; })
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=format-overflow -Wno-error=class-memaccess -Wno-error=stringop-truncation";

  preConfigure = ''
    # Fix cases where makedev(),major(),minor() are referenced through
    # <sys/types.h> instead of <sys/sysmacros.h>
    sed 1i'#include <sys/sysmacros.h>' -i src/linux/fs.cpp
    sed 1i'#include <sys/sysmacros.h>' -i src/slave/containerizer/mesos/isolators/gpu/isolator.cpp
    substituteInPlace 3rdparty/stout/include/stout/os/posix/chown.hpp \
      --subst-var-by chown ${coreutils}/bin/chown

    substituteInPlace configure.ac \
      --replace "-lprotobuf" \
                "${protobuf}/lib/libprotobuf.a"

    substituteInPlace 3rdparty/stout/Makefile.am \
      --replace "-lprotobuf" \
                "${protobuf}/lib/libprotobuf.a"

    substituteInPlace 3rdparty/stout/include/stout/os/posix/fork.hpp \
      --subst-var-by sh ${bash}/bin/bash

    substituteInPlace 3rdparty/stout/include/stout/posix/os.hpp \
      --subst-var-by tar ${tarWithGzip}/bin/tar

    substituteInPlace 3rdparty/libprocess/Makefile.am \
      --replace "-lprotobuf" \
                "${protobuf}/lib/libprotobuf.a"

    substituteInPlace src/cli/mesos-scp \
      --subst-var-by scp ${openssh}/bin/scp

    substituteInPlace src/common/command_utils.cpp \
      --subst-var-by curl      ${curl}/bin/curl \
      --subst-var-by gzip      ${gzip}/bin/gzip \
      --subst-var-by sha512sum ${coreutils}/bin/sha512sum \
      --subst-var-by tar       ${tarWithGzip}/bin/tar

    substituteInPlace src/launcher/fetcher.cpp \
      --subst-var-by cp    ${coreutils}/bin/cp \
      --subst-var-by gzip  ${gzip}/bin/gzip \
      --subst-var-by tar   ${tarWithGzip}/bin/tar \
      --subst-var-by unzip ${unzip}/bin/unzip

    substituteInPlace src/python/cli/src/mesos/cli.py \
      --subst-var-by mesos-resolve $out/bin/mesos-resolve

    substituteInPlace src/python/native_common/ext_modules.py.in \
      --replace "-lprotobuf" \
                "${protobuf}/lib/libprotobuf.a"

    substituteInPlace src/slave/containerizer/mesos/isolators/gpu/volume.cpp \
      --subst-var-by cp    ${coreutils}/bin/cp \
      --subst-var-by which ${which}/bin/which

    substituteInPlace src/slave/containerizer/mesos/isolators/posix/disk.cpp \
      --subst-var-by du ${coreutils}/bin/du

    substituteInPlace src/slave/containerizer/mesos/provisioner/backends/copy.cpp \
      --subst-var-by cp ${coreutils}/bin/cp \
      --subst-var-by rm ${coreutils}/bin/rm

    substituteInPlace src/uri/fetchers/copy.cpp \
      --subst-var-by cp ${coreutils}/bin/cp

    substituteInPlace src/uri/fetchers/curl.cpp \
      --subst-var-by curl ${curl}/bin/curl

    substituteInPlace src/uri/fetchers/docker.cpp \
      --subst-var-by curl ${curl}/bin/curl

    substituteInPlace src/Makefile.am \
      --subst-var-by mavenRepo ${mavenRepo} \
      --replace "-lprotobuf" \
                "${protobuf}/lib/libprotobuf.a"

  '' + lib.optionalString stdenv.isLinux ''

    substituteInPlace src/linux/perf.cpp \
      --subst-var-by perf ${linuxPackages.perf}/bin/perf

    substituteInPlace src/slave/containerizer/mesos/isolators/docker/volume/isolator.cpp \
      --subst-var-by mount ${utillinux}/bin/mount

    substituteInPlace src/slave/containerizer/mesos/isolators/filesystem/linux.cpp \
      --subst-var-by mount ${utillinux}/bin/mount

    substituteInPlace src/slave/containerizer/mesos/isolators/filesystem/shared.cpp \
      --subst-var-by mount ${utillinux}/bin/mount

    substituteInPlace src/slave/containerizer/mesos/isolators/gpu/isolator.cpp \
      --subst-var-by mount ${utillinux}/bin/mount

    substituteInPlace src/slave/containerizer/mesos/isolators/namespaces/pid.cpp \
      --subst-var-by mount ${utillinux}/bin/mount

    substituteInPlace src/slave/containerizer/mesos/isolators/network/cni/cni.cpp \
      --subst-var-by mount ${utillinux}/bin/mount

    substituteInPlace src/slave/containerizer/mesos/isolators/network/cni/plugins/port_mapper/port_mapper.cpp \
      --subst-var-by iptables ${iptables}/bin/iptables

    substituteInPlace src/slave/containerizer/mesos/isolators/network/port_mapping.cpp \
      --subst-var-by ethtool ${ethtool}/sbin/ethtool \
      --subst-var-by ip      ${iproute}/bin/ip \
      --subst-var-by mount   ${utillinux}/bin/mount \
      --subst-var-by tc      ${iproute}/bin/tc

    substituteInPlace src/slave/containerizer/mesos/isolators/volume/image.cpp \
      --subst-var-by mount   ${utillinux}/bin/mount

    substituteInPlace src/slave/containerizer/mesos/isolators/volume/sandbox_path.cpp \
      --subst-var-by mount   ${utillinux}/bin/mount
  '';

  configureFlags = [
    "--sbindir=\${out}/bin"
    "--enable-ssl"
    "--enable-libevent"
    "--with-ssl=${openssl.dev}"
    "--with-libevent=${libevent.dev}"
    "--with-libev=${libev}"
    "--with-apr=${apr.dev}"
    "--with-svn=${subversion.dev}"
    "--with-leveldb=${leveldb}"
    "--with-grpc=${grpc}"
    "--with-libarchive=${libarchive.dev}"
    "--with-zookeeper=${zookeeper_mt}"
    "--with-protobuf=${protobuf}"
    "--with-glog=${glog}"
    "--with-boost=${boost165.dev}"
    "--with-gmock=${gmock.src}/googlemock"
    "--with-rapidjson=${rapidjson}"
    "--enable-optimize"
    "--disable-python-dependency-install"
   #"--enable-jemalloc-allocator" # <-- as for 0.10.0, typos in src/Makefile.in prevents to enable jemalloc
   #"--with-jemalloc=${jemalloc}"
   #"--enable-new-cli"            # <-- it requires python3
    "PROTOBUF_JAR=${mavenRepo}/com/google/protobuf/protobuf-java/3.5.0/protobuf-java-3.5.0.jar"
    (if withJava then "--enable-java" else "--disable-java")
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-launcher-sealing"
    "--enable-port-mapping-isolator"
    "--with-nl=${libnl.dev}"
    "--enable-seccomp-isolator"
    "--with-libseccomp=${libseccomp.dev}"
  ];

  postInstall = ''
    rm $out/bin/*.sh

    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"

    # # Inspired by: pkgs/development/python-modules/generic/default.nix
    # pushd src/python
    # mkdir -p $out/lib/${python.libPrefix}/site-packages
    # ${python}/bin/${python.executable} setup.py install \
    #   --install-lib=$out/lib/${python.libPrefix}/site-packages \
    #   --old-and-unmanageable \
    #   --prefix="$out"
    # rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*
    # popd
    #
    # # optional python dependency for mesos cli
    # pushd src/python/cli
    # ${python}/bin/${python.executable} setup.py install \
    #   --install-lib=$out/lib/${python.libPrefix}/site-packages \
    #   --old-and-unmanageable \
    #   --prefix="$out"
    # popd
  '' + lib.optionalString withJava ''
    mkdir -p $out/share/java
    cp src/java/target/mesos-*.jar $out/share/java

    mkdir -p $out/nix-support
    echo "export MESOS_NATIVE_JAVA_LIBRARY=$out/lib/libmesos${stdenv.hostPlatform.extensions.sharedLibrary}" >> $out/nix-support/setup-hook
  '';

  postFixup = ''
    # if test -e $out/nix-support/propagated-build-inputs; then
    #   ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    # fi
    #
    # for inputsfile in propagated-build-inputs propagated-native-build-inputs; do
    #   if test -e $out/nix-support/$inputsfile; then
    #     createBuildInputsPth $inputsfile "$(cat $out/nix-support/$inputsfile)"
    #   fi
    # done
    #
    # for f in $out/libexec/mesos/python/mesos/*.py; do
    #   ${python}/bin/${python.executable} -c "import py_compile; py_compile.compile('$f')"
    # done

    # wrap the python programs
    for prog in mesos-cat mesos-ps mesos-scp mesos-tail; do
      wrapProgram "$out/bin/$prog" \
        --prefix PYTHONPATH ":" "$out/lib/${python.libPrefix}/site-packages"
      true
    done
  '';

  meta = with lib; {
    homepage    = "http://mesos.apache.org";
    license     = licenses.asl20;
    description = "A cluster manager that provides efficient resource isolation and sharing across distributed applications, or frameworks";
    maintainers = with maintainers; [ cstrahan kevincox offline ];
    platforms   = platforms.unix;
  };
}
