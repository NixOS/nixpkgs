{ lib
, stdenv
, mkDerivation
, fetchurl
, fetchpatch
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, cmake
, boost
, zlib
, openssl
, R
, qtbase
, qtxmlpatterns
, qtsensors
, qtwebengine
, qtwebchannel
, libuuid
, hunspellDicts
, unzip
, ant
, jdk
, gnumake
, makeWrapper
, pandoc
, llvmPackages
, yaml-cpp
, soci
, postgresql
, nodejs
, mkYarnModules
, qmake
, server ? false # build server version
, sqlite
, pam
, nixosTests
}:

let
  pname = "RStudio";
  version = "2022.07.1+554";
  RSTUDIO_VERSION_MAJOR  = "2022";
  RSTUDIO_VERSION_MINOR  = "07";
  RSTUDIO_VERSION_PATCH  = "1";
  RSTUDIO_VERSION_SUFFIX = "+554";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rstudio";
    rev = "v${version}";
    sha256 = "0rmdqxizxqg2vgr3lv066cjmlpjrxjlgi0m97wbh6iyhkfm2rrj1";
  };

  mathJaxSrc = fetchurl {
    url = "https://s3.amazonaws.com/rstudio-buildtools/mathjax-27.zip";
    sha256 = "sha256-xWy6psTOA8H8uusrXqPDEtL7diajYCVHcMvLiPsgQXY=";
  };

  rsconnectSrc = fetchFromGitHub {
    owner = "rstudio";
    repo = "rsconnect";
    rev = "e287b586e7da03105de3faa8774c63f08984eb3c";
    sha256 = "sha256-ULyWdSgGPSAwMt0t4QPuzeUE6Bo6IJh+5BMgW1bFN+Y=";
  };

  panmirrorModules = mkYarnModules {
    inherit pname version;
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarndeps.nix;
  };

  description = "Set of integrated tools for the R language";
in
(if server then stdenv.mkDerivation else mkDerivation)
  (rec {
    inherit pname version src RSTUDIO_VERSION_MAJOR RSTUDIO_VERSION_MINOR RSTUDIO_VERSION_PATCH RSTUDIO_VERSION_SUFFIX;

    nativeBuildInputs = [
      cmake
      unzip
      ant
      jdk
      makeWrapper
      pandoc
      nodejs
    ] ++ lib.optionals (!server) [
      copyDesktopItems
    ];

    buildInputs = [
      boost
      zlib
      openssl
      R
      libuuid
      yaml-cpp
      soci
      postgresql
    ] ++ (if server then [
      sqlite.dev
      pam
    ] else [
      qtbase
      qtxmlpatterns
      qtsensors
      qtwebengine
      qtwebchannel
    ]);

    cmakeFlags = [
      "-DRSTUDIO_TARGET=${if server then "Server" else "Desktop"}"
      "-DCMAKE_BUILD_TYPE=Release"
      "-DRSTUDIO_USE_SYSTEM_SOCI=ON"
      "-DRSTUDIO_USE_SYSTEM_BOOST=ON"
      "-DRSTUDIO_USE_SYSTEM_YAML_CPP=ON"
      "-DQUARTO_ENABLED=FALSE"
      "-DPANDOC_VERSION=${pandoc.version}"
      "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/lib/rstudio"
    ] ++ lib.optionals (!server) [
      "-DQT_QMAKE_EXECUTABLE=${qmake}/bin/qmake"
    ];

    # Hack RStudio to only use the input R and provided libclang.
    patches = [
      ./r-location.patch
      ./clang-location.patch
      ./use-system-node.patch
      ./fix-resources-path.patch
      ./pandoc-nix-path.patch
      ./remove-quarto-from-generator.patch
      ./do-not-install-pandoc.patch
    ];

    postPatch = ''
      substituteInPlace src/cpp/core/r_util/REnvironmentPosix.cpp --replace '@R@' ${R}

      substituteInPlace src/cpp/CMakeLists.txt \
        --replace 'SOCI_LIBRARY_DIR "/usr/lib"' 'SOCI_LIBRARY_DIR "${soci}/lib"'

      substituteInPlace src/gwt/build.xml \
        --replace '@node@' ${nodejs}

      substituteInPlace src/cpp/core/libclang/LibClang.cpp \
        --replace '@libclang@' ${llvmPackages.libclang.lib} \
        --replace '@libclang.so@' ${llvmPackages.libclang.lib}/lib/libclang.so

      substituteInPlace src/cpp/session/include/session/SessionConstants.hpp \
        --replace '@pandoc@' ${pandoc}/bin/pandoc
    '';

    hunspellDictionaries = with lib; filter isDerivation (unique (attrValues hunspellDicts));
    # These dicts contain identically-named dict files, so we only keep the
    # -large versions in case of clashes
    largeDicts = with lib; filter (d: hasInfix "-large-wordlist" d.name) hunspellDictionaries;
    otherDicts = with lib; filter
      (d: !(hasAttr "dictFileName" d &&
        elem d.dictFileName (map (d: d.dictFileName) largeDicts)))
      hunspellDictionaries;
    dictionaries = largeDicts ++ otherDicts;

    preConfigure = ''
      mkdir dependencies/dictionaries
      for dict in ${builtins.concatStringsSep " " dictionaries}; do
        for i in "$dict/share/hunspell/"*; do
          ln -s $i dependencies/dictionaries/
        done
      done

      unzip -q ${mathJaxSrc} -d dependencies/mathjax-27

      mkdir -p dependencies/pandoc/${pandoc.version}
      cp ${pandoc}/bin/pandoc dependencies/pandoc/${pandoc.version}/pandoc

      cp -r ${rsconnectSrc} dependencies/rsconnect
      ( cd dependencies && ${R}/bin/R CMD build -d --no-build-vignettes rsconnect )

      cp -r "${panmirrorModules}" src/gwt/panmirror/src/editor/node_modules
    '';

    postInstall = ''
      mkdir -p $out/bin $out/share

      ${lib.optionalString (!server) ''
        mkdir -p $out/share/icons/hicolor/48x48/apps
        ln $out/lib/rstudio/rstudio.png $out/share/icons/hicolor/48x48/apps
      ''}

      for f in {${if server
        then "crash-handler-proxy,postback,r-ldpath,rpostback,rserver,rserver-pam,rsession,rstudio-server"
        else "diagnostics,rpostback,rstudio"}}; do
        ln -s $out/lib/rstudio/bin/$f $out/bin
      done

      for f in .gitignore .Rbuildignore LICENSE README; do
        find . -name $f -delete
      done

      rm -r $out/lib/rstudio/{INSTALL,COPYING,NOTICE,README.md,SOURCE,VERSION}
    '';

    meta = with lib; {
      broken = (stdenv.isLinux && stdenv.isAarch64);
      inherit description;
      homepage = "https://www.rstudio.com/";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ ciil cfhammill ];
      mainProgram = "rstudio" + lib.optionalString server "-server";
      platforms = platforms.linux;
    };

    passthru = {
      inherit server;
      tests = { inherit (nixosTests) rstudio-server; };
    };
  } // lib.optionalAttrs (!server) {
    qtWrapperArgs = [
      "--suffix PATH : ${lib.makeBinPath [ gnumake ]}"
    ];

    desktopItems = [
      (makeDesktopItem {
        name = pname;
        exec = "rstudio %F";
        icon = "rstudio";
        desktopName = "RStudio";
        genericName = "IDE";
        comment = description;
        categories = [ "Development" ];
        mimeTypes = [
          "text/x-r-source" "text/x-r" "text/x-R" "text/x-r-doc" "text/x-r-sweave" "text/x-r-markdown"
          "text/x-r-html" "text/x-r-presentation" "application/x-r-data" "application/x-r-project"
          "text/x-r-history" "text/x-r-profile" "text/x-tex" "text/x-markdown" "text/html"
          "text/css" "text/javascript" "text/x-chdr" "text/x-csrc" "text/x-c++hdr" "text/x-c++src"
        ];
      })
    ];
  })
