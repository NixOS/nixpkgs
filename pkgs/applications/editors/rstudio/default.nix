{ stdenv, fetchurl, makeDesktopItem, cmake, boost163, zlib, openssl,
R, qt5, libuuid, hunspellDicts, unzip, ant, jdk, gnumake, makeWrapper,
# If you have set up an R wrapper with other packages by following
# something like https://nixos.org/nixpkgs/manual/#r-packages, RStudio
# by default not be able to access any of those R packages. In order
# to do this, override the argument "R" here with your respective R
# wrapper, and set "useRPackages" to true.  This will add the
# environment variable R_PROFILE_USER to the RStudio wrapper, pointing
# to an R script which will allow R to use these packages.
useRPackages ? false
}:

let
  version = "1.1.135";
  ginVer = "1.5";
  gwtVer = "2.5.1";
in
stdenv.mkDerivation rec {
  name = "RStudio-${version}";

  buildInputs = [ cmake boost163 zlib openssl R qt5.full qt5.qtwebkit libuuid unzip ant jdk makeWrapper ];

  src = fetchurl {
    url = "https://github.com/rstudio/rstudio/archive/v${version}.tar.gz";
    sha256 = "1jgzn053qx4b34i8x9wkvw66zfscvj96xdhaw4dby3vssgsip4h4";
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

  hunspellDictionaries = builtins.attrValues hunspellDicts;

  mathJaxSrc = fetchurl {
    url = https://s3.amazonaws.com/rstudio-buildtools/mathjax-26.zip;
    sha256 = "0wbcqb9rbfqqvvhqr1pbqax75wp8ydqdyhp91fbqfqp26xzjv6lk";
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
      for dict in $hunspellDictionaries; do
          for i in "$dict/share/hunspell/"*
	  do ln -sv $i dependencies/common/dictionaries/
	  done
      done

      unzip $mathJaxSrc -d dependencies/common/mathjax-26
    '';

  cmakeFlags = [ "-DRSTUDIO_TARGET=Desktop" ];

  desktopItem = makeDesktopItem {
    name = name;
    exec = "rstudio %F";
    icon = "rstudio";
    desktopName = "RStudio";
    genericName = "IDE";
    comment = meta.description;
    categories = "Development;";
    mimeType = "text/x-r-source;text/x-r;text/x-R;text/x-r-doc;text/x-r-sweave;text/x-r-markdown;text/x-r-html;text/x-r-presentation;application/x-r-data;application/x-r-project;text/x-r-history;text/x-r-profile;text/x-tex;text/x-markdown;text/html;text/css;text/javascript;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;";
  };

  postInstall = let rProfile =
    # RStudio seems to bypass the environment variables that the R
    # wrapper already applies, and so this sets R_PROFILE_USER to
    # again make those R packages accessible:
    if useRPackages
    then "--set R_PROFILE_USER ${R}/${R.passthru.fixLibsR}" else "";
    in ''
      wrapProgram $out/bin/rstudio --suffix PATH : ${gnumake}/bin ${rProfile}
      mkdir $out/share
      cp -r ${desktopItem}/share/applications $out/share
      mkdir $out/share/icons
      ln $out/rstudio.png $out/share/icons
  '';

  meta = with stdenv.lib;
    { description = "Set of integrated tools for the R language";
      homepage = http://www.rstudio.com/;
      license = licenses.agpl3;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
