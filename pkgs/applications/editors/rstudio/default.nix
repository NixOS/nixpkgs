{ lib
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
, libyamlcpp
, soci
, postgresql
, nodejs
, mkYarnModules
, qmake
}:

let
  pname = "RStudio";
  version = "1.4.1717";
  RSTUDIO_VERSION_MAJOR = lib.versions.major version;
  RSTUDIO_VERSION_MINOR = lib.versions.minor version;
  RSTUDIO_VERSION_PATCH = lib.versions.patch version;

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rstudio";
    rev = "v${version}";
    sha256 = "sha256-9c1bNsf8kJjpcZ2cMV/pPNtXQkFOntX29a1cdnXpllE=";
  };

  mathJaxSrc = fetchurl {
    url = "https://s3.amazonaws.com/rstudio-buildtools/mathjax-27.zip";
    sha256 = "sha256-xWy6psTOA8H8uusrXqPDEtL7diajYCVHcMvLiPsgQXY=";
  };

  rsconnectSrc = fetchFromGitHub {
    owner = "rstudio";
    repo = "rsconnect";
    rev = "f5854bb71464f6e3017da9855f058fe3d5b32efd";
    sha256 = "sha256-ULyWdSgGPSAwMt0t4QPuzeUE6Bo6IJh+5BMgW1bFN+Y=";
  };

  panmirrorModules = mkYarnModules {
    inherit pname version;
    packageJSON = ./package.json;
    yarnLock =  ./yarn.lock;
    yarnNix = ./yarndeps.nix;
  };

in
mkDerivation rec {
  inherit pname version src RSTUDIO_VERSION_MAJOR RSTUDIO_VERSION_MINOR RSTUDIO_VERSION_PATCH;

  nativeBuildInputs = [
    cmake
    unzip
    ant
    jdk
    makeWrapper
    pandoc
    nodejs
    copyDesktopItems
  ];

  buildInputs = [
    boost
    zlib
    openssl
    R
    qtbase
    qtxmlpatterns
    qtsensors
    qtwebengine
    qtwebchannel
    libuuid
    libyamlcpp
    soci
    postgresql
  ];

  cmakeFlags = [
    "-DRSTUDIO_TARGET=Desktop"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DQT_QMAKE_EXECUTABLE=${qmake}/bin/qmake"
    "-DRSTUDIO_USE_SYSTEM_SOCI=ON"
    "-DRSTUDIO_USE_SYSTEM_BOOST=ON"
    "-DRSTUDIO_USE_SYSTEM_YAML_CPP=ON"
    "-DPANDOC_VERSION=${pandoc.version}"
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/lib/rstudio"
  ];

  # Hack RStudio to only use the input R and provided libclang.
  patches = [
    ./r-location.patch
    ./clang-location.patch
    # postFetch doesn't work with this | error: unexpected end-of-file
    # replacing /usr/bin/node is done in postPatch
    # https://src.fedoraproject.org/rpms/rstudio/tree/rawhide
    (fetchpatch {
      name = "system-node.patch";
      url = "https://src.fedoraproject.org/rpms/rstudio/raw/5bda2e290c9e72305582f2011040938d3e356906/f/0004-use-system-node.patch";
      sha256 = "sha256-P1Y07RB/ceFNa749nyBUWSE41eiiZgt43zVcmahvfZM=";
    })
  ];

  postPatch = ''
    substituteInPlace src/cpp/core/r_util/REnvironmentPosix.cpp --replace '@R@' ${R}

    substituteInPlace src/cpp/CMakeLists.txt \
      --replace 'SOCI_LIBRARY_DIR "/usr/lib"' 'SOCI_LIBRARY_DIR "${soci}/lib"'

    substituteInPlace src/gwt/build.xml \
      --replace '/usr/bin/node' '${nodejs}/bin/node'

    substituteInPlace src/cpp/core/libclang/LibClang.cpp \
      --replace '@libclang@' ${llvmPackages.libclang.lib} \
      --replace '@libclang.so@' ${llvmPackages.libclang.lib}/lib/libclang.so

      substituteInPlace src/cpp/session/include/session/SessionConstants.hpp \
        --replace "bin/pandoc" "${pandoc}/bin/pandoc"
  '';

  hunspellDictionaries = with lib; filter isDerivation (unique (attrValues hunspellDicts));
  # These dicts contain identically-named dict files, so we only keep the
  # -large versions in case of clashes
  largeDicts = with lib; filter (d: hasInfix "-large-wordlist" d) hunspellDictionaries;
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
    mkdir -p $out/share/icons $out/bin
    ln $out/lib/rstudio/rstudio.png $out/share/icons

    for f in {diagnostics,rpostback,rstudio}; do
      ln -s $out/lib/rstudio/bin/$f $out/bin
    done

    for f in .gitignore .Rbuildignore LICENSE README; do
      find . -name $f -delete
    done
    rm -r $out/lib/rstudio/{INSTALL,COPYING,NOTICE,README.md,SOURCE,VERSION}
    rm -r $out/lib/rstudio/bin/{pandoc/pandoc,pandoc}
  '';

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ gnumake ]}"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "${pname}";
      exec = "rstudio %F";
      icon = "rstudio";
      desktopName = "RStudio";
      genericName = "IDE";
      comment = meta.description;
      categories = "Development;";
      mimeType = "text/x-r-source;text/x-r;text/x-R;text/x-r-doc;text/x-r-sweave;text/x-r-markdown;text/x-r-html;text/x-r-presentation;application/x-r-data;application/x-r-project;text/x-r-history;text/x-r-profile;text/x-tex;text/x-markdown;text/html;text/css;text/javascript;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;";
    })
  ];

  meta = with lib; {
    description = "Set of integrated tools for the R language";
    homepage = "https://www.rstudio.com/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ciil ];
    platforms = platforms.linux;
  };
}
