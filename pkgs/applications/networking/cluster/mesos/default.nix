{ stdenv, lib, makeWrapper, fetchurl, curl, sasl, openssh
, unzip, gnutar, jdk, python, wrapPython
, setuptools, boto, pythonProtobuf, apr, subversion, gzip
, leveldb, glog, perf, utillinux, libnl, iproute, openssl, libevent
, ethtool, coreutils, which, iptables, maven
, bash, autoreconfHook
, utf8proc, lz4
, withJava ? !stdenv.isDarwin
}:

let
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
  version = "1.4.1";
  name = "mesos-${version}";

  enableParallelBuilding = true;
  dontDisableStatic = true;

  src = fetchurl {
    url = "mirror://apache/mesos/${version}/${name}.tar.gz";
    sha256 = "1c7l0rim9ija913gpppz2mcms08ywyqhlzbbspqsi7wwfdd7jwsr";
  };

  patches = [
    # https://reviews.apache.org/r/36610/
    # TODO: is this still needed?
    ./rb36610.patch

    # see https://github.com/cstrahan/mesos/tree/nixos-${version}
    ./nixos.patch
  ];
  nativeBuildInputs = [
    autoreconfHook
  ];
  buildInputs = [
    makeWrapper curl sasl
    python wrapPython boto setuptools leveldb
    subversion apr glog openssl libevent
    utf8proc lz4
  ] ++ lib.optionals stdenv.isLinux [
    libnl
  ] ++ lib.optionals withJava [
    jdk maven
  ];

  propagatedBuildInputs = [
    pythonProtobuf
  ];
  preConfigure = ''
    # https://issues.apache.org/jira/browse/MESOS-6616
    configureFlagsArray+=(
      "CXXFLAGS=-O2 -Wno-error=strict-aliasing"
    )

    substituteInPlace 3rdparty/stout/include/stout/jsonify.hpp \
      --replace '<xlocale.h>' '<locale.h>'
    # Fix cases where makedev(),major(),minor() are referenced through
    # <sys/types.h> instead of <sys/sysmacros.h>
    sed 1i'#include <sys/sysmacros.h>' -i src/linux/fs.cpp
    sed 1i'#include <sys/sysmacros.h>' -i src/slave/containerizer/mesos/isolators/gpu/isolator.cpp
    substituteInPlace 3rdparty/stout/include/stout/os/posix/chown.hpp \
      --subst-var-by chown ${coreutils}/bin/chown

    substituteInPlace 3rdparty/stout/Makefile.am \
      --replace "-lprotobuf" \
                "${pythonProtobuf.protobuf}/lib/libprotobuf.a"

    substituteInPlace 3rdparty/stout/include/stout/os/posix/fork.hpp \
      --subst-var-by sh ${bash}/bin/bash

    substituteInPlace 3rdparty/stout/include/stout/posix/os.hpp \
      --subst-var-by tar ${tarWithGzip}/bin/tar

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
                "${pythonProtobuf.protobuf}/lib/libprotobuf.a"

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
                "${pythonProtobuf.protobuf}/lib/libprotobuf.a"

  '' + lib.optionalString stdenv.isLinux ''

    substituteInPlace src/linux/perf.cpp \
      --subst-var-by perf ${perf}/bin/perf

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
    "--with-apr=${apr.dev}"
    "--with-svn=${subversion.dev}"
    "--with-leveldb=${leveldb}"
    "--with-glog=${glog}"
    "--enable-optimize"
    "--disable-python-dependency-install"
    "--enable-ssl"
    "--with-ssl=${openssl.dev}"
    "--enable-libevent"
    "--with-libevent=${libevent.dev}"
    "--with-protobuf=${pythonProtobuf.protobuf}"
    "PROTOBUF_JAR=${mavenRepo}/com/google/protobuf/protobuf-java/3.3.0/protobuf-java-3.3.0.jar"
    (if withJava then "--enable-java" else "--disable-java")
  ] ++ lib.optionals stdenv.isLinux [
    "--with-network-isolator"
    "--with-nl=${libnl.dev}"
  ];

  postInstall = ''
    rm -rf $out/var
    rm $out/bin/*.sh

    # Inspired by: pkgs/development/python-modules/generic/default.nix
    pushd src/python
    mkdir -p $out/lib/${python.libPrefix}/site-packages
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --old-and-unmanageable \
      --prefix="$out"
    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*
    popd

    # optional python dependency for mesos cli
    pushd src/python/cli
    ${python}/bin/${python.executable} setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --old-and-unmanageable \
      --prefix="$out"
    popd
  '' + stdenv.lib.optionalString withJava ''
    mkdir -p $out/share/java
    cp src/java/target/mesos-*.jar $out/share/java

    MESOS_NATIVE_JAVA_LIBRARY=$out/lib/libmesos${stdenv.hostPlatform.extensions.sharedLibrary}

    mkdir -p $out/nix-support
    touch $out/nix-support/setup-hook
    echo "export MESOS_NATIVE_JAVA_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY" >> $out/nix-support/setup-hook
    echo "export MESOS_NATIVE_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY" >> $out/nix-support/setup-hook
  '';

  postFixup = ''
    if test -e $out/nix-support/propagated-build-inputs; then
      ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi

    for inputsfile in propagated-build-inputs propagated-native-build-inputs; do
      if test -e $out/nix-support/$inputsfile; then
        createBuildInputsPth $inputsfile "$(cat $out/nix-support/$inputsfile)"
      fi
    done

    for f in $out/libexec/mesos/python/mesos/*.py; do
      ${python}/bin/${python.executable} -c "import py_compile; py_compile.compile('$f')"
    done

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
