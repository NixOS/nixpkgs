{ stdenv, fetchurl, fetchFromGitHub, makeDesktopItem, cmake, boost, zlib
, openssl, R, qtbase, qtxmlpatterns, qtsensors, qtwebengine, qtwebchannel
, libuuid, hunspellDicts, unzip, ant, jdk, gnumake, makeWrapper, pandoc
, llvmPackages
}:

let
  rev = "f79330d4";
  ginVer = "2.1.2";
  gwtVer = "2.8.1";
in
stdenv.mkDerivation rec {
  name = "RStudio-preview-${rev}";

  nativeBuildInputs = [ cmake unzip ant jdk makeWrapper pandoc ];

  buildInputs = [ boost zlib openssl R qtbase qtxmlpatterns qtsensors
                  qtwebengine qtwebchannel libuuid ];

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rstudio";
    inherit rev;
    sha256 = "0v3vzqjp74c3m4h9l6w2lrdnjqaimdjzbf7vhnlxj2qa0lwsnykb";
  };

  # Hack RStudio to only use the input R and provided libclang.
  patches = [ ./r-location.patch ./clang-location.patch ];
  postPatch = ''
    substituteInPlace src/cpp/core/r_util/REnvironmentPosix.cpp --replace '@R@' ${R}
    substituteInPlace src/cpp/core/libclang/LibClang.cpp \
      --replace '@clang@' ${llvmPackages.clang.cc} \
      --replace '@libclang.so@' ${llvmPackages.clang.cc.lib}/lib/libclang.so
  '';

  ginSrc = fetchurl {
    url = "https://s3.amazonaws.com/rstudio-buildtools/gin-${ginVer}.zip";
    sha256 = "16jzmljravpz6p2rxa87k5f7ir8vs7ya75lnfybfajzmci0p13mr";
  };

  gwtSrc = fetchurl {
    url = "https://s3.amazonaws.com/rstudio-buildtools/gwt-${gwtVer}.zip";
    sha256 = "19x000m3jwnkqgi6ic81lkzyjvvxcfacw2j0vcfcaknvvagzhyhb";
  };

  hunspellDictionaries = with stdenv.lib; filter isDerivation (attrValues hunspellDicts);

  mathJaxSrc = fetchurl {
    url = https://s3.amazonaws.com/rstudio-buildtools/mathjax-26.zip;
    sha256 = "0wbcqb9rbfqqvvhqr1pbqax75wp8ydqdyhp91fbqfqp26xzjv6lk";
  };

  rsconnectSrc = fetchFromGitHub {
    owner = "rstudio";
    repo = "rsconnect";
    rev = "984745d8";
    sha256 = "037z0y32k1gdda192y5qn5hi7wp8wyap44mkjlklrgcqkmlcylb9";
  };

  preConfigure =
    ''
      GWT_LIB_DIR=src/gwt/lib

      mkdir -p $GWT_LIB_DIR/gin/${ginVer}
      unzip ${ginSrc} -d $GWT_LIB_DIR/gin/${ginVer}

      unzip ${gwtSrc}
      mkdir -p $GWT_LIB_DIR/gwt
      mv gwt-${gwtVer} $GWT_LIB_DIR/gwt/${gwtVer}

      mkdir dependencies/common/dictionaries
      for dict in ${builtins.concatStringsSep " " hunspellDictionaries}; do
        for i in "$dict/share/hunspell/"*; do
          ln -sv $i dependencies/common/dictionaries/
        done
      done

      unzip ${mathJaxSrc} -d dependencies/common/mathjax-26

      mkdir -p dependencies/common/pandoc
      cp ${pandoc}/bin/pandoc dependencies/common/pandoc/

      cp -r ${rsconnectSrc} dependencies/common/rsconnect
      pushd dependencies/common
      ${R}/bin/R CMD build -d --no-build-vignettes rsconnect
      popd
    '';

  enableParallelBuilding = true;

  cmakeFlags = [ "-DRSTUDIO_TARGET=Desktop" "-DQT_QMAKE_EXECUTABLE=$NIX_QT5_TMP/bin/qmake" ];

  desktopItem = makeDesktopItem {
    name = name;
    exec = "rstudio %F";
    icon = "rstudio";
    desktopName = "RStudio Preview";
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
      maintainers = with maintainers; [ averelld ];
      platforms = platforms.linux;
    };
}
