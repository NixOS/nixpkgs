{ stdenv, fetchurl, perl, nettools, java, polyml }:
# nettools needed for hostname

let
  dirname = "Isabelle2016";
  theories = ["HOL" "FOL" "ZF"];
in

stdenv.mkDerivation {
  name = "isabelle-2016";
  inherit dirname theories;

  src = if stdenv.isDarwin
    then fetchurl {
      url = "http://isabelle.in.tum.de/website-${dirname}/dist/${dirname}.dmg";
      sha256 = "0wawf0cjc52h8hif1867p33qhlh6qz0fy5i2kr1gbf7psickd6iw";
    }
    else fetchurl {
      url = "http://isabelle.in.tum.de/website-${dirname}/dist/${dirname}_linux.tar.gz";
      sha256 = "0jh1qrsyib13fycymwvw7dq7xfy4iyplwq0s65ash842cdzkbxb4";
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
      --subst-var-by ML_HOME "${polyml}/bin"
    substituteInPlace contrib/jdk/etc/settings \
      --replace ISABELLE_JDK_HOME= '#ISABELLE_JDK_HOME='
    substituteInPlace contrib/polyml-*/etc/settings \
      --replace '$POLYML_HOME/$ML_PLATFORM' ${polyml}/bin \
      --replace '$POLYML_HOME/$PLATFORM/polyml' ${polyml}/bin/poly
    substituteInPlace lib/scripts/run-polyml* lib/scripts/polyml-version \
      --replace '$ML_HOME/poly' ${polyml}/bin/poly
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
