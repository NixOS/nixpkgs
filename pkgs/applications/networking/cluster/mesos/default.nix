{ stdenv, lib, makeWrapper, fetchurl, fetchzip, curl, sasl, openssh, autoconf
, automake, libtool, unzip, gnutar, jdk, maven, python, wrapPython
, setuptools, distutils-cfg, boto, pythonProtobuf
}:

let version = "0.19.1";
in stdenv.mkDerivation {
  dontDisableStatic = true;

  name = "mesos-${version}";

  src = fetchurl {
    url = "http://www.apache.org/dist/mesos/${version}/mesos-${version}.tar.gz";
    sha256 = "12li5xqfcw3124qg3h2cji3yhrc7gbx91lj45zfliicwgjkbmyf1";
  };

  patches = [ ./darwin.patch ];

  buildInputs = [
    makeWrapper autoconf automake libtool curl sasl jdk maven
    python wrapPython boto distutils-cfg
  ];

  propagatedBuildInputs = [
    pythonProtobuf
  ];

  mavenRepo = import ./mesos-deps.nix { inherit stdenv curl; };

  preConfigure = ''
    export MAVEN_OPTS="-Dmaven.repo.local=$(pwd)/.m2"
    ln -s $mavenRepo .m2

    substituteInPlace src/launcher/fetcher.cpp \
      --replace '"tar' '"${gnutar}/bin/tar'    \
      --replace '"unzip' '"${unzip}/bin/unzip'

    substituteInPlace src/cli/mesos-scp        \
      --replace "'scp " "'${openssh}/bin/scp "
  '';

  configureFlags = [
    "--sbindir=\${out}/bin"
    "--with-python-headers=${python}/include"
    "--with-webui"
    "--with-java-home=${jdk}"
    "--with-java-headers=${jdk}/include"
    "--with-included-zookeeper"
  ];

  postInstall = ''
    rm -rf $out/var
    rm $out/bin/*.sh

    ensureDir $out/share/java
    cp src/java/target/mesos-*.jar $out/share/java

    shopt -s extglob
    MESOS_NATIVE_JAVA_LIBRARY=$(echo $out/lib/libmesos.*(so|dylib))
    shopt -u extglob

    ensureDir $out/nix-support
    touch $out/nix-support/setup-hook
    echo "export MESOS_NATIVE_JAVA_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY" >> $out/nix-support/setup-hook
    echo "export MESOS_NATIVE_LIBRARY=$MESOS_NATIVE_JAVA_LIBRARY" >> $out/nix-support/setup-hook

    # Inspired by: pkgs/development/python-modules/generic/default.nix
    ensureDir "$out/lib/${python.libPrefix}"/site-packages
    export PYTHONPATH="$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
    ${python}/bin/${python.executable} src/python/setup.py install \
      --install-lib=$out/lib/${python.libPrefix}/site-packages \
      --old-and-unmanageable \
      --prefix="$out"
    rm -f "$out/lib/${python.libPrefix}"/site-packages/site.py*
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

    # wrap the python programs
    declare -A pythonPathsSeen=()
    program_PYTHONPATH="$out/libexec/mesos/python"
    program_PATH=""
    _addToPythonPath "$out"
    for prog in mesos-cat mesos-ps mesos-scp mesos-tail; do
      wrapProgram "$out/bin/$prog" \
        --prefix PYTHONPATH ":" $program_PYTHONPATH
      true
    done
  '';

  meta = with lib; {
    homepage    = "http://mesos.apache.org";
    license     = licenses.asl20;
    description = "A cluster manager that provides efficient resource isolation and sharing across distributed applications, or frameworks";
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux;
  };
}
