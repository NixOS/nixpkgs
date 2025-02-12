{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  replaceVars,
  cmake,
  boost186,
  zlib,
  openssl,
  R,
  libsForQt5,
  quarto,
  libuuid,
  hunspellDicts,
  ant,
  jdk,
  gnumake,
  pandoc,
  llvmPackages,
  yaml-cpp,
  soci,
  sqlite,
  nodejs,
  yarn,
  yarnConfigHook,
  fetchYarnDeps,
  server ? false, # build server version
  pam,
  nixosTests,
}:

let
  mathJaxSrc = fetchzip {
    url = "https://s3.amazonaws.com/rstudio-buildtools/mathjax-27.zip";
    hash = "sha256-J7SZK/9q3HcXTD7WFHxvh++ttuCd89Vc4SEBrUEU0AI=";
  };

  # Ideally, rev should match the rstudio release name.
  # e.g. release/rstudio-mountain-hydrangea
  quartoSrc = fetchFromGitHub {
    owner = "quarto-dev";
    repo = "quarto";
    rev = "bb264a572c6331d46abcf087748c021d815c55d7";
    hash = "sha256-lZnZvioztbBWWa6H177X6rRrrgACx2gMjVFDgNup93g=";
  };

  hunspellDictionaries = lib.filter lib.isDerivation (lib.unique (lib.attrValues hunspellDicts));
  # These dicts contain identically-named dict files, so we only keep the
  # -large versions in case of clashes
  largeDicts = lib.filter (d: lib.hasInfix "-large-wordlist" d.name) hunspellDictionaries;
  otherDicts = lib.filter (
    d: !(lib.hasAttr "dictFileName" d && lib.elem d.dictFileName (map (d: d.dictFileName) largeDicts))
  ) hunspellDictionaries;
  dictionaries = largeDicts ++ otherDicts;
in
stdenv.mkDerivation rec {
  pname = "RStudio";
  version = "2024.04.2+764";

  RSTUDIO_VERSION_MAJOR = lib.versions.major version;
  RSTUDIO_VERSION_MINOR = lib.versions.minor version;
  RSTUDIO_VERSION_PATCH = lib.versions.patch version;
  RSTUDIO_VERSION_SUFFIX = "+" + toString (lib.tail (lib.splitString "+" version));

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rstudio";
    rev = "refs/tags/v${version}";
    hash = "sha256-j258eW1MYQrB6kkpjyolXdNuwQ3zSWv9so4q0QLsZuw=";
  };

  nativeBuildInputs =
    [
      cmake
      ant
      jdk
      nodejs
      yarn
      yarnConfigHook
    ]
    ++ lib.optionals (!server) [
      libsForQt5.wrapQtAppsHook
    ];

  buildInputs =
    [
      boost186
      zlib
      openssl
      R
      libuuid
      yaml-cpp
      soci
      sqlite.dev
    ]
    ++ lib.optionals server [ pam ]
    ++ lib.optionals (!server) [
      libsForQt5.qtbase
      libsForQt5.qtxmlpatterns
      libsForQt5.qtsensors
      libsForQt5.qtwebengine
      libsForQt5.qtwebchannel
    ];

  cmakeFlags =
    [
      (lib.cmakeFeature "RSTUDIO_TARGET" (if server then "Server" else "Desktop"))
      (lib.cmakeBool "RSTUDIO_USE_SYSTEM_SOCI" true)
      (lib.cmakeBool "RSTUDIO_USE_SYSTEM_BOOST" true)
      (lib.cmakeBool "RSTUDIO_USE_SYSTEM_YAML_CPP" true)
      (lib.cmakeBool "RSTUDIO_DISABLE_CHECK_FOR_UPDATES" true)
      (lib.cmakeBool "QUARTO_ENABLED" true)
      (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib/rstudio")
    ]
    ++ lib.optionals (!server) [
      (lib.cmakeFeature "QT_QMAKE_EXECUTABLE" "${libsForQt5.qmake}/bin/qmake")
      (lib.cmakeBool "RSTUDIO_INSTALL_FREEDESKTOP" true)
    ];

  patches = [
    # Hack RStudio to only use the input R and provided libclang.
    (replaceVars ./r-location.patch {
      R = lib.getBin R;
    })
    (replaceVars ./clang-location.patch {
      libclang = lib.getLib llvmPackages.libclang;
    })

    ./fix-resources-path.patch
    ./ignore-etc-os-release.patch
    ./dont-yarn-install.patch
    ./dont-assume-pandoc-in-quarto.patch
    ./boost-1.86.patch
  ];

  postPatch = ''
    # fix .desktop Exec field
    substituteInPlace src/node/desktop/resources/freedesktop/rstudio.desktop.in \
      --replace-fail "''${CMAKE_INSTALL_PREFIX}/rstudio" "rstudio"

    # set install path of freedesktop files
    substituteInPlace src/{cpp,node}/desktop/CMakeLists.txt \
      --replace-fail "/usr/share" "$out/share"
  '';

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = quartoSrc + "/yarn.lock";
    hash = "sha256-Qw8O1Jzl2EO0DEF3Jrw/cIT9t22zs3jyKgDA5XZbuGA=";
  };

  dontYarnInstallDeps = true; # will call manually in preConfigure

  preConfigure = ''
    # set up node_modules directory inside quarto so that panmirror can be built
    mkdir src/gwt/lib/quarto
    cp -r --no-preserve=all ${quartoSrc}/* src/gwt/lib/quarto
    pushd src/gwt/lib/quarto
    yarnConfigHook
    popd

    ### set up dependencies that will be copied into the result
    # note: only the directory names have to match upstream, the actual versions don't
    # note: symlinks are preserved

    mkdir dependencies/dictionaries
    for dict in ${builtins.concatStringsSep " " dictionaries}; do
      for i in "$dict/share/hunspell/"*; do
        ln -s $i dependencies/dictionaries/
      done
    done

    ln -s ${quarto} dependencies/quarto

    # version in dependencies/common/install-mathjax
    ln -s ${mathJaxSrc} dependencies/mathjax-27

    # version in CMakeGlobals.txt (PANDOC_VERSION)
    mkdir -p dependencies/pandoc/2.18
    ln -s ${lib.getBin pandoc}/bin/* dependencies/pandoc/2.18

    # version in CMakeGlobals.txt (RSTUDIO_INSTALLED_NODE_VERSION)
    mkdir -p dependencies/common/node
    ln -s ${nodejs} dependencies/common/node/18.20.3
  '';

  postInstall = ''
    mkdir -p $out/bin

    ${lib.optionalString server ''
      ln -s $out/lib/rstudio/bin/{crash-handler-proxy,postback,r-ldpath,rpostback,rserver,rserver-pam,rsession,rstudio-server} $out/bin
    ''}

    ${lib.optionalString (!server) ''
      ln -s $out/lib/rstudio/bin/{diagnostics,rpostback,rstudio} $out/bin
    ''}
  '';

  qtWrapperArgs = lib.optionals (!server) [
    "--suffix PATH : ${lib.makeBinPath [ gnumake ]}"
  ];

  passthru = {
    inherit server;
    tests = {
      inherit (nixosTests) rstudio-server;
    };
  };

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Set of integrated tools for the R language";
    homepage = "https://www.rstudio.com/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ciil
      cfhammill
    ];
    mainProgram = "rstudio" + lib.optionalString server "-server";
    platforms = lib.platforms.linux;
  };
}
