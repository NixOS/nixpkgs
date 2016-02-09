{ stdenv, fetchurl, cmake, boost155, zlib, openssl, R, qt4, libuuid, hunspellDicts, unzip, ant, jdk, gnumake, makeWrapper }:

let
  version = "0.98.110";
  ginVer = "1.5";
  gwtVer = "2.5.1";
in
stdenv.mkDerivation {
  name = "RStudio-${version}";

  buildInputs = [ cmake boost155 zlib openssl R qt4 libuuid unzip ant jdk makeWrapper ];

  src = fetchurl {
    url = "https://github.com/rstudio/rstudio/archive/v${version}.tar.gz";
    sha256 = "0wybbvl5libki8z2ywgcd0hg0py1az484r95lhwh3jbrwfx7ri2z";
  };

  # Hack RStudio to only use the input R.
  patches = [ ./r-location.patch ];
  postPatch = "substituteInPlace src/cpp/core/r_util/REnvironmentPosix.cpp --replace '@R@' ${R}";

  inherit ginVer;
  ginSrc = fetchurl {
    url = "https://s3.amazonaws.com/rstudio-buildtools/gin-${ginVer}.zip";
    sha256 = "155bjrgkf046b8ln6a55x06ryvm8agnnl7l8bkwwzqazbpmz8qgm";
  };

  inherit gwtVer;
  gwtSrc = fetchurl {
    url = "https://s3.amazonaws.com/rstudio-buildtools/gwt-${gwtVer}.zip";
    sha256 = "0fjr2rcr8lnywj54mzhg9i4xz1b6fh8yv12p5i2q5mgfld2xymy4";
  };

  hunspellDicts = builtins.attrValues hunspellDicts;

  mathJaxSrc = fetchurl {
    url = https://s3.amazonaws.com/rstudio-buildtools/mathjax-20.zip;
    sha256 = "1ikg3fhharsfrh2fv8c53fdawqajj24nif89400l3klw1hyq4zal";
  };

  preConfigure =
    ''
      GWT_LIB_DIR=src/gwt/lib

      mkdir -p $GWT_LIB_DIR/gin/$ginVer
      unzip $ginSrc -d $GWT_LIB_DIR/gin/$ginVer

      unzip $gwtSrc
      mkdir -p $GWT_LIB_DIR/gwt
      mv gwt-$gwtVer $GWT_LIB_DIR/gwt/$gwtVer

      mkdir dependencies/common/dictionaries
      for dict in $hunspellDicts; do
          for i in "$dict/share/hunspell/"*
	  do ln -sv $i dependencies/common/dictionaries/
	  done
      done

      unzip $mathJaxSrc -d dependencies/common/mathjax
    '';

  cmakeFlags = [ "-DRSTUDIO_TARGET=Desktop" ];

  postInstall = ''
      wrapProgram $out/bin/rstudio --suffix PATH : ${gnumake}/bin
  '';

  meta = with stdenv.lib;
    { description = "Set of integrated tools for the R language";
      homepage = http://www.rstudio.com/;
      license = licenses.agpl3;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
