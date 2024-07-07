{ lib
, stdenv
, mkDerivation
, fetchurl
, fetchpatch
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, cmake
, boost183
, zlib
, openssl
, R
, qtbase
, qtxmlpatterns
, qtsensors
, qtwebengine
, qtwebchannel
, quarto
, libuuid
, hunspellDicts
, unzip
, ant
, jdk
, gnumake
, pandoc
, llvmPackages
, yaml-cpp
, soci
, postgresql
, nodejs
, qmake
, server ? false # build server version
, sqlite
, pam
, nixosTests
}:

let
  pname = "RStudio";
  version = "2024.04.1+748";
  RSTUDIO_VERSION_MAJOR = lib.versions.major version;
  RSTUDIO_VERSION_MINOR = lib.versions.minor version;
  RSTUDIO_VERSION_PATCH = lib.versions.patch version;
  RSTUDIO_VERSION_SUFFIX = "+" + toString (
    lib.tail (lib.splitString "+" version)
  );

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rstudio";
    rev = "v" + version;
    hash = "sha256-fzxbhN9NdM0E2rxezj2BMEZ8obUbX0Zw8haDNmfAkWs=";
  };

  mathJaxSrc = fetchurl {
    url = "https://s3.amazonaws.com/rstudio-buildtools/mathjax-27.zip";
    hash = "sha256-xWy6psTOA8H8uusrXqPDEtL7diajYCVHcMvLiPsgQXY=";
  };

  rsconnectSrc = fetchFromGitHub {
    owner = "rstudio";
    repo = "rsconnect";
    rev = "v1.2.2";
    hash = "sha256-wvM9Bm7Nb6yU9z0o+uF5lB2kdgjOW5wZSk6y48NPF2U=";
  };

  # Ideally, rev should match the rstudio release name.
  # e.g. release/rstudio-mountain-hydrangea
  quartoSrc = fetchFromGitHub {
    owner = "quarto-dev";
    repo = "quarto";
    rev = "bb264a572c6331d46abcf087748c021d815c55d7";
    hash = "sha256-lZnZvioztbBWWa6H177X6rRrrgACx2gMjVFDgNup93g=";
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
      pandoc
      nodejs
    ] ++ lib.optionals (!server) [
      copyDesktopItems
    ];

    buildInputs = [
      boost183
      zlib
      openssl
      R
      libuuid
      yaml-cpp
      soci
      postgresql
      quarto
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
      "-DRSTUDIO_USE_SYSTEM_SOCI=ON"
      "-DRSTUDIO_USE_SYSTEM_BOOST=ON"
      "-DRSTUDIO_USE_SYSTEM_YAML_CPP=ON"
      "-DRSTUDIO_DISABLE_CHECK_FOR_UPDATES=ON"
      "-DQUARTO_ENABLED=TRUE"
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
      ./use-system-quarto.patch
      ./ignore-etc-os-release.patch

      (fetchpatch {
        name = "use-system-yaml-patch";
        url = "https://github.com/rstudio/rstudio/commit/04de8ca8b83dcc7fee9fd65e6ef58c372489d5ef.patch";
        hash = "sha256-FHSSOPsw6AAYBj/fgNT6idyxvRj3SG+fbla0UDjug1Y=";
      })

    ];

    postPatch = ''
      substituteInPlace src/cpp/core/r_util/REnvironmentPosix.cpp --replace '@R@' ${R}

      substituteInPlace src/cpp/CMakeLists.txt \
        --replace 'SOCI_LIBRARY_DIR "/usr/lib"' 'SOCI_LIBRARY_DIR "${soci}/lib"'

      substituteInPlace src/gwt/build.xml \
        --replace '@node@' ${nodejs} \
        --replace './lib/quarto' ${quartoSrc}

      substituteInPlace src/cpp/conf/rsession-dev.conf \
        --replace '@node@' ${nodejs}

      substituteInPlace src/cpp/core/libclang/LibClang.cpp \
        --replace '@libclang@' ${llvmPackages.libclang.lib} \
        --replace '@libclang.so@' ${llvmPackages.libclang.lib}/lib/libclang.so

      substituteInPlace src/cpp/session/CMakeLists.txt \
        --replace '@pandoc@' ${pandoc} \
        --replace '@quarto@' ${quarto}

      substituteInPlace src/cpp/session/include/session/SessionConstants.hpp \
        --replace '@pandoc@' ${pandoc}/bin \
        --replace '@quarto@' ${quarto}
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

     # As of Chocolate Cosmos, node 18.19.1 is used for runtime
     # 18.18.2 is still used for build
     # see https://github.com/rstudio/rstudio/commit/facb5cf1ab38fe77813aaf36590804e4f865d780
     mkdir -p dependencies/common/node/18.19.1

      mkdir -p dependencies/pandoc/${pandoc.version}
      cp ${pandoc}/bin/pandoc dependencies/pandoc/${pandoc.version}/pandoc

      cp -r ${rsconnectSrc} dependencies/rsconnect
      ( cd dependencies && ${R}/bin/R CMD build -d --no-build-vignettes rsconnect )
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

    meta = {
      broken = (stdenv.isLinux && stdenv.isAarch64);
      inherit description;
      homepage = "https://www.rstudio.com/";
      license = lib.licenses.agpl3Only;
      maintainers = with lib.maintainers; [ ciil cfhammill ];
      mainProgram = "rstudio" + lib.optionalString server "-server";
      platforms = lib.platforms.linux;
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
