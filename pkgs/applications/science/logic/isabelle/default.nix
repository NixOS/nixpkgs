{ lib, stdenv, fetchurl, callPackage, runCommand, coreutils, perl, perlPackages
, makeWrapper, nettools, java, polyml, z3, rlwrap, naproche }:
# nettools needed for hostname

let
  sha1 = callPackage ./sha1.nix {};
  ml_home = runCommand "ml-home" {} ''
    mkdir $out
    ln -s ${polyml}/bin/* $out
    ln -s ${polyml}/lib/* $out
    ln -s ${sha1}/lib/* $out
  '';
in

stdenv.mkDerivation rec {
  pname = "isabelle";
  version = "2021";

  dirname = "Isabelle${version}";

  src = if stdenv.isDarwin
    then fetchurl {
      url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_macos.tar.gz";
      sha256 = "1c2qm2ksmpyxyccyyn4lyj2wqj5m74nz2i0c5abrd1hj45zcnh1m";
    }
    else fetchurl {
      url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_linux.tar.gz";
      sha256 = "1isgc9w4q95638dcag9gxz1kmf97pkin3jz1dm2lhd64b2k12y2x";
    };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ naproche perl ml_home z3 ]
             ++ lib.optionals (!stdenv.isDarwin) [ nettools java ];

  sourceRoot = dirname;

  postPatch = ''
    patchShebangs .

    cat >contrib/z3*/etc/settings <<EOF
      Z3_HOME=${z3}
      Z3_VERSION=${z3.version}
      Z3_SOLVER=${z3}/bin/z3
      Z3_INSTALLED=yes
    EOF

    cat >contrib/polyml-*/etc/settings <<EOF
      ML_SYSTEM_64=true
      ML_SYSTEM=${polyml.name}
      ML_PLATFORM=${stdenv.system}
      ML_HOME=${ml_home}
      ML_OPTIONS="--minheap 1000"
      POLYML_HOME="\$COMPONENT"
      ML_SOURCES="\$POLYML_HOME/src"
    EOF

    cat >contrib/jdk*/etc/settings <<EOF
      ISABELLE_JAVA_PLATFORM=${stdenv.system}
      ISABELLE_JDK_HOME=${java}
    EOF

    rm contrib/naproche*/x86*/Naproche-SAD
    ln -s ${naproche}/bin/Naproche-SAD contrib/naproche*/x86*/

    echo ISABELLE_LINE_EDITOR=${rlwrap}/bin/rlwrap >>etc/settings

    for comp in contrib/jdk* contrib/polyml-* contrib/z3-*; do
      rm -rf $comp/x86*
    done
    '' + (if ! stdenv.isLinux then "" else ''
    arch=${if stdenv.hostPlatform.system == "x86_64-linux" then "x86_64-linux" else "x86-linux"}
    for f in contrib/*/$arch/{bash_process,epclextract,eprover,nunchaku,SPASS}; do
      patchelf --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) "$f"
    done

    substituteInPlace src/Pure/System/isabelle_system.scala \
      --replace 'List("/usr/bin/env", "bash")' 'List("'$SHELL'")'

    substituteInPlace lib/Tools/env \
      --replace /usr/bin/env ${coreutils}/bin/env

    echo 'PATH="${perl}/bin:$PATH"' >> etc/settings

    rm -r lib/classes heaps
    '');

  buildPhase = ''
    bin/isabelle env src/Pure/build-jars
    bin/isabelle build -v -o system_heaps -b HOL
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $TMP/$dirname $out
    cd $out/$dirname
    bin/isabelle install $out/bin

    wrapProgram $out/$dirname/src/HOL/Tools/ATP/scripts/remote_atp --set PERL5LIB ${perlPackages.makeFullPerlPath [ perlPackages.LWP ]}
  '';

  meta = with lib; {
    description = "A generic proof assistant";

    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = "https://isabelle.in.tum.de/";
    license = licenses.bsd3;
    maintainers = [ maintainers.jwiegley ];
    platforms = platforms.linux;
  };
}
