{ stdenv, lib, makeWrapper, fetchurl, curl, sasl, openssh, autoconf
, automake115x, libtool, unzip, gnutar, jdk, maven, python, wrapPython
, setuptools, boto, pythonProtobuf, apr, subversion, gzip, systemd
, leveldb, glog, perf, utillinux, libnl, iproute, openssl, libevent
, bash
}:

let
  mavenRepo = import ./mesos-deps.nix { inherit stdenv curl; };
  soext = if stdenv.system == "x86_64-darwin" then "dylib" else "so";

in stdenv.mkDerivation rec {
  version = "0.28.0";
  name = "mesos-${version}";

  enableParallelBuilding = true;
  dontDisableStatic = true;

  src = fetchurl {
    url = "mirror://apache/mesos/${version}/${name}.tar.gz";
    sha256 = "05dnj6r5pspizna0fk7yayn38a4w9hlcswgg8l9qmb35m6nq6hby";
  };

  patches = [
    # https://reviews.apache.org/r/36610/
    ./rb36610.patch
    ./maven_repo.patch
  ];

  buildInputs = [
    makeWrapper autoconf automake115x libtool curl sasl jdk maven
    python wrapPython boto setuptools leveldb
    subversion apr glog openssl libevent
  ] ++ lib.optionals stdenv.isLinux [
    libnl
  ];

  propagatedBuildInputs = [
    pythonProtobuf
  ];

  preConfigure = ''
    substituteInPlace src/Makefile.am --subst-var-by mavenRepo ${mavenRepo}
    
    substituteInPlace 3rdparty/libprocess/include/process/subprocess.hpp \
      --replace '"sh"' '"${bash}/bin/bash"'

    substituteInPlace 3rdparty/libprocess/3rdparty/stout/include/stout/posix/os.hpp \
      --replace '"sh"' '"${bash}/bin/bash"'

    substituteInPlace 3rdparty/libprocess/3rdparty/stout/include/stout/os/posix/fork.hpp \
      --replace '"sh"' '"${bash}/bin/bash"'

    substituteInPlace src/cli/mesos-scp        \
      --replace "'scp " "'${openssh}/bin/scp "

    substituteInPlace src/launcher/executor.cpp \
      --replace '"sh"' '"${bash}/bin/bash"'
    
    substituteInPlace src/launcher/fetcher.cpp \
      --replace '"gzip' '"${gzip}/bin/gzip'    \
      --replace '"tar' '"${gnutar}/bin/tar'    \
      --replace '"unzip' '"${unzip}/bin/unzip'

    substituteInPlace src/python/cli/src/mesos/cli.py \
     --replace "['mesos-resolve'" "['$out/bin/mesos-resolve'"
    
    substituteInPlace src/slave/containerizer/mesos/launch.cpp \
      --replace '"sh"' '"${bash}/bin/bash"'

  '' + lib.optionalString stdenv.isLinux ''

    substituteInPlace configure.ac             \
      --replace /usr/include/libnl3 ${libnl}/include/libnl3

    substituteInPlace src/linux/perf.cpp       \
      --replace '"perf ' '"${perf}/bin/perf '
    
    substituteInPlace src/linux/systemd.cpp \
      --replace 'os::realpath("/sbin/init")' '"${systemd}/lib/systemd/systemd"'

    substituteInPlace src/slave/containerizer/mesos/isolators/filesystem/shared.cpp \
      --replace '"mount ' '"${utillinux}/bin/mount ' \

    substituteInPlace src/slave/containerizer/mesos/isolators/namespaces/pid.cpp \
      --replace '"mount ' '"${utillinux}/bin/mount ' \

    substituteInPlace src/slave/containerizer/mesos/isolators/network/port_mapping.cpp \
      --replace '"tc ' '"${iproute}/bin/tc '   \
      --replace '"ip ' '"${iproute}/bin/ip '   \
      --replace '"mount ' '"${utillinux}/bin/mount ' \
      --replace '/bin/sh' "${stdenv.shell}"
  '';

  configureFlags = [
    "--sbindir=\${out}/bin"
    "--with-apr=${apr.dev}"
    "--with-svn=${subversion}"
    "--with-leveldb=${leveldb}"
    "--with-glog=${glog}"
    "--with-glog=${glog}"
    "--enable-optimize"
    "--disable-python-dependency-install"
    "--enable-ssl"
    "--with-ssl=${openssl}"
    "--enable-libevent"
    "--with-libevent=${libevent.dev}"
  ] ++ lib.optionals stdenv.isLinux [
    "--with-network-isolator"
  ];

  postInstall = ''
    rm -rf $out/var
    rm $out/bin/*.sh

    mkdir -p $out/share/java
    cp src/java/target/mesos-*.jar $out/share/java

    MESOS_NATIVE_JAVA_LIBRARY=$out/lib/libmesos.${soext}

    mkdir -p $out/nix-support
    touch $out/nix-support/setup-hook
    echo "export MESOS_NATIVE_JAVA_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY" >> $out/nix-support/setup-hook
    echo "export MESOS_NATIVE_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY" >> $out/nix-support/setup-hook

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
    maintainers = with maintainers; [ cstrahan kevincox offline rushmorem ];
    platforms   = platforms.linux;
  };
}
