{ stdenv, fetchurl, perl, nettools, java, polyml, proofgeneral }:
# nettools needed for hostname

let
  dirname = "Isabelle2015";
  theories = ["HOL" "FOL" "ZF"];
in

stdenv.mkDerivation {
  name = "isabelle-2015";
  inherit dirname theories;

  src = if stdenv.isDarwin
    then fetchurl {
      url = http://isabelle.in.tum.de/dist/Isabelle2015.dmg;
      sha256 = "1vhm10qc1rn3wy9r12clrl33p64h3q1aj41mcnxkbnsyg2bx03im";
    }
    else fetchurl {
      url = http://isabelle.in.tum.de/dist/Isabelle2015_linux.tar.gz;
      sha256 = "13kqm458d8mw7il1zg5bdb1nfbb869p331d75xzlm2v9xgjxx862";
    };

  buildInputs = [ perl polyml ]
             ++ stdenv.lib.optionals (!stdenv.isDarwin) [ nettools java ];

  sourceRoot = dirname;

  postPatch = ''
    ENV=$(type -p env)
    patchShebangs "."
    substituteInPlace lib/Tools/env \
      --replace /usr/bin/env $ENV
    substituteInPlace lib/Tools/install \
      --replace /usr/bin/env $ENV
    sed -i 's|isabelle_java java|${java}/bin/java|g' lib/Tools/java
    substituteInPlace etc/settings \
      --subst-var-by ML_HOME "${polyml}/bin" \
      --subst-var-by PROOFGENERAL_HOME "${proofgeneral}/share/emacs/site-lisp/ProofGeneral"
    substituteInPlace contrib/jdk/etc/settings \
      --replace ISABELLE_JDK_HOME= '#ISABELLE_JDK_HOME='
    substituteInPlace contrib/polyml-*/etc/settings \
      --replace 'ML_HOME="$POLYML_HOME/$ML_PLATFORM"' \
                "ML_HOME=\"${polyml}/bin\""
  '';

  buildPhase = ''
    ISABELLE_JDK_HOME=${java} ./bin/isabelle build -s $theories
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv $TMP/$dirname $out
    cd $out/$dirname
    bin/isabelle install $out/bin
  '';

  meta = {
    description = "A generic proof assistant";

    longDescription = ''
      Isabelle is a generic proof assistant.  It allows mathematical formulas
      to be expressed in a formal language and provides tools for proving those
      formulas in a logical calculus.
    '';
    homepage = http://isabelle.in.tum.de/;
    license = "LGPL";
    maintainers = [ stdenv.lib.maintainers.jwiegley ];
  };
}
