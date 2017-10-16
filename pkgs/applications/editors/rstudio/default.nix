{ stdenv, fetchurl, fetchpatch, makeDesktopItem, cmake, boost163, zlib, openssl,
R, qt5, libuuid, hunspellDicts, unzip, ant, jdk, gnumake, makeWrapper, pandoc
}:

let
  version = "1.1.383";
  ginVer = "1.5";
  gwtVer = "2.7.0";
in
stdenv.mkDerivation rec {
  name = "RStudio-${version}";

  buildInputs = [ cmake boost163 zlib openssl R qt5.full qt5.qtwebkit qt5.qtwebchannel libuuid unzip ant jdk makeWrapper pandoc ];

  src = fetchurl {
    url = "https://github.com/rstudio/rstudio/archive/v${version}.tar.gz";
    sha256 = "06680l9amq03b4jarmzfr605bijhb79fip9rk464zab6hgwqbp3f";
  };

  # Hack RStudio to only use the input R.
  patches = [ 
    ./r-location.patch 
    (fetchpatch {
      url = https://aur.archlinux.org/cgit/aur.git/plain/socketproxy-openssl.patch?h=rstudio-desktop-git;
      sha256 = "0ywq9rk14s5961l6hvd3cw70jsm73r16h0bsh4yp52vams7cwy9d";
    })
  ];
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

  rmarkdownSrc = fetchurl {
    url = "https://github.com/rstudio/rmarkdown/archive/95b8b1fa64f78ca99f225a67fff9817103be56.zip";
    sha256 = "12fa65qr04rwsprkmyl651mkaqcbn1znwsmcjg4qsk9n5nxg0fah";
  };

  rsconnectSrc = fetchurl {
    url = "https://github.com/rstudio/rsconnect/archive/425f3767b3142bc6b81c9eb62c4722f1eedc9781.zip";
    sha256 = "1sgf9dj9wfk4c6n5p1jc45386pf0nj2alg2j9qx09av3can1dy9p";
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
      unzip $rmarkdownSrc -d dependencies/common/rmarkdown
      unzip $rsconnectSrc -d dependencies/common/rsconnect
      mkdir -p dependencies/common/libclang/3.5
      unzip $rstudiolibclang -d dependencies/common/libclang/3.5
      mkdir -p dependencies/common/libclang/builtin-headers
      unzip $rstudiolibclangheaders -d dependencies/common/libclang/builtin-headers

      mkdir -p dependencies/common/pandoc
      cp ${pandoc}/bin/pandoc dependencies/common/pandoc/
    '';

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
      homepage = http://www.rstudio.com/;
      license = licenses.agpl3;
      maintainers = with maintainers; [ ehmry changlinli ciil ];
      platforms = platforms.linux;
    };
}
