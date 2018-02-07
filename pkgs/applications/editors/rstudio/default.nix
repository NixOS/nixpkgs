{ stdenv, fetchurl, fetchFromGitHub, makeDesktopItem, cmake, boost
, zlib, openssl, R, qtbase, qtwebkit, qtwebchannel, libuuid, hunspellDicts
, unzip, ant, jdk, gnumake, makeWrapper, pandoc
}:

let
  version = "1.1.414";
  ginVer = "1.5";
  gwtVer = "2.7.0";
in
stdenv.mkDerivation rec {
  name = "RStudio-${version}";

  nativeBuildInputs = [ cmake unzip ant jdk makeWrapper pandoc ];

  buildInputs = [ boost zlib openssl R qtbase qtwebkit qtwebchannel libuuid ];

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rstudio";
    rev = "v${version}";
    sha256 = "1rr2zkv53r8swhq5d745jpp0ivxpsizzh7srf34isqpkn5pgx3v8";
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
    sha256 = "1cs78z9a1jg698j2n35wsy07cy4fxcia9gi00x0r0qc3fcdhcrda";
  };

  hunspellDictionaries = builtins.attrValues hunspellDicts;

  mathJaxSrc = fetchurl {
    url = https://s3.amazonaws.com/rstudio-buildtools/mathjax-26.zip;
    sha256 = "0wbcqb9rbfqqvvhqr1pbqax75wp8ydqdyhp91fbqfqp26xzjv6lk";
  };

  rmarkdownSrc = fetchFromGitHub {
    owner = "rstudio";
    repo = "rmarkdown";
    rev = "v1.8";
    sha256 = "1blqxdr1vp2z5wd52nmf8hq36sdd4s2pyms441dqj50v35f8girb";
  };

  rsconnectSrc = fetchFromGitHub {
    owner = "rstudio";
    repo = "rsconnect";
    rev = "953c945779dd180c1bfe68f41c173c13ec3e222d";
    sha256 = "1yxwd9v4mvddh7m5rbljicmssw7glh1lhin7a9f01vxxa92vpj7z";
  };

  rstudiolibclang = fetchurl {
    url = https://s3.amazonaws.com/rstudio-buildtools/libclang-3.5.zip;
    sha256 = "1sl5vb8misipwbbbykdymw172w9qrh8xv3p29g0bf3nzbnv6zc7c";
  };

  rstudiolibclangheaders = fetchurl {
    url = https://s3.amazonaws.com/rstudio-buildtools/libclang-builtin-headers.zip;
    sha256 = "0x4ax186bm3kf098izwmsplckgx1kqzg9iiyzg95rpbqsb4593qb";
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
      mkdir -p dependencies/common/rmarkdown
      ln -s $rmarkdownSrc dependencies/common/rmarkdown/
      mkdir -p dependencies/common/rsconnect
      ln -s $rsconnectSrc dependencies/common/rsconnect/
      mkdir -p dependencies/common/libclang/3.5
      unzip $rstudiolibclang -d dependencies/common/libclang/3.5
      mkdir -p dependencies/common/libclang/builtin-headers
      unzip $rstudiolibclangheaders -d dependencies/common/libclang/builtin-headers

      mkdir -p dependencies/common/pandoc
      cp ${pandoc}/bin/pandoc dependencies/common/pandoc/
    '';

  enableParallelBuilding = true;

  cmakeFlags = [ "-DRSTUDIO_TARGET=Desktop" "-DQT_QMAKE_EXECUTABLE=$NIX_QT5_TMP/bin/qmake" ];

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

  postInstall = ''
      wrapProgram $out/bin/rstudio --suffix PATH : ${gnumake}/bin
      mkdir $out/share
      cp -r ${desktopItem}/share/applications $out/share
      mkdir $out/share/icons
      ln $out/rstudio.png $out/share/icons
  '';

  meta = with stdenv.lib;
    { description = "Set of integrated tools for the R language";
      homepage = https://www.rstudio.com/;
      license = licenses.agpl3;
      maintainers = with maintainers; [ ehmry changlinli ciil ];
      platforms = platforms.linux;
    };
}
