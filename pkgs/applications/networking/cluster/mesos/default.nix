{ stdenv, lib, makeWrapper, fetchurl, curl, sasl, openssh, autoconf
, automake114x, libtool, unzip, gnutar, jdk, maven, python, wrapPython
, setuptools, boto, pythonProtobuf, apr, subversion
, leveldb, glog, perf, utillinux, libnl, iproute
}:

let
  mavenRepo = import ./mesos-deps.nix { inherit stdenv curl; };
  soext = if stdenv.system == "x86_64-darwin" then "dylib" else "so";

in stdenv.mkDerivation rec {
  version = "0.23.0";
  name = "mesos-${version}";

  dontDisableStatic = true;

  src = fetchurl {
    url = "mirror://apache/mesos/${version}/${name}.tar.gz";
    sha256 = "1v5xpn4wal4vcrvcklchx9slkpa8xlwqkdbnxzy9zkzpq5g3arxr";
  };

  patches = [
    # https://reviews.apache.org/r/36610/
    ./rb36610.patch
  ];

  buildInputs = [
    makeWrapper autoconf automake114x libtool curl sasl jdk maven
    python wrapPython boto setuptools leveldb
    subversion apr glog
  ] ++ lib.optionals stdenv.isLinux [
    libnl
  ];

  propagatedBuildInputs = [
    pythonProtobuf
  ];

  preConfigure = ''
    export MAVEN_OPTS="-Dmaven.repo.local=${mavenRepo}"

    substituteInPlace src/launcher/fetcher.cpp \
      --replace '"tar' '"${gnutar}/bin/tar'    \
      --replace '"unzip' '"${unzip}/bin/unzip'

    substituteInPlace src/cli/mesos-scp        \
      --replace "'scp " "'${openssh}/bin/scp "

    substituteInPlace src/cli/python/mesos/cli.py \
      --replace "['mesos-resolve'" "['$out/bin/mesos-resolve'"

  '' + lib.optionalString (stdenv.isLinux) ''

    substituteInPlace configure.ac             \
      --replace /usr/include/libnl3 ${libnl}/include/libnl3

    substituteInPlace src/linux/perf.cpp       \
      --replace '"perf ' '"${perf}/bin/perf '

    substituteInPlace src/slave/containerizer/isolators/filesystem/shared.cpp \
      --replace '"mount ' '"${utillinux}/bin/mount ' \

    substituteInPlace src/slave/containerizer/isolators/namespaces/pid.cpp \
      --replace '"mount ' '"${utillinux}/bin/mount ' \

    substituteInPlace src/slave/containerizer/isolators/network/port_mapping.cpp \
      --replace '"tc ' '"${iproute}/bin/tc '   \
      --replace '"ip ' '"${iproute}/bin/ip '   \
      --replace '"mount ' '"${utillinux}/bin/mount ' \
      --replace '/bin/sh' "${stdenv.shell}"
  '';

  configureFlags = [
    "--sbindir=\${out}/bin"
    "--with-apr=${apr}"
    "--with-svn=${subversion}"
    "--with-leveldb=${leveldb}"
    "--with-glog=${glog}"
    "--with-glog=${glog}"
    "--enable-optimize"
    "--disable-python-dependency-install"
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
        --prefix PYTHONPATH ":" "$out/libexec/mesos/python"
      true
    done
  '';

  meta = with lib; {
    homepage    = "http://mesos.apache.org";
    license     = licenses.asl20;
    description = "A cluster manager that provides efficient resource isolation and sharing across distributed applications, or frameworks";
    maintainers = with maintainers; [ cstrahan offline rushmorem ];
    platforms   = platforms.linux;
  };
}
