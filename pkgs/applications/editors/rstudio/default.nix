{
  lib,
  stdenv,
  runCommand,
  fetchzip,
  fetchFromGitHub,
  replaceVars,
  cmake,
  boost186,
  zlib,
  openssl,
  R,
  fontconfig,
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
  apple-sdk_11,
  xcbuild,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  yarn,
  yarnConfigHook,
  fetchYarnDeps,
  zip,
  git,
  makeWrapper,
  electron_33,
  server ? false, # build server version
  pam,
  nixosTests,
}:

let
  # Note: we shouldn't use the latest electron here, since the node-abi dependency might
  # need to be updated every time the latest electron gets a new abi version number
  electron = electron_33;

  # unpack tarball containing electron's headers
  electron-headers = runCommand "electron-headers" { } ''
    mkdir -p $out
    tar -C $out --strip-components=1 -xvf ${electron.headers}
  '';

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

  # rstudio assumes quarto bundles pandoc into bin/tools/
  quartoWrapper = runCommand "quarto-wrapper" { } ''
    mkdir -p $out/bin/tools
    ln -s ${lib.getExe pandoc} $out/bin/tools/pandoc
    ln -s ${lib.getExe quarto} $out/bin/quarto
    ln -s ${quarto}/share $out/share
  '';
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
    tag = "v${version}";
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
      zip
      git
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ]
    ++ lib.optionals (!server) [
      (nodejs.python.withPackages (ps: [ ps.setuptools ]))
      npmHooks.npmConfigHook
      makeWrapper
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ]
    ++ lib.optionals server [ pam ]
    ++ lib.optionals (!server) [ fontconfig ];

  cmakeFlags =
    [
      (lib.cmakeFeature "RSTUDIO_TARGET" (if server then "Server" else "Electron"))
      (lib.cmakeBool "RSTUDIO_USE_SYSTEM_SOCI" true)
      (lib.cmakeBool "RSTUDIO_USE_SYSTEM_BOOST" true)
      (lib.cmakeBool "RSTUDIO_USE_SYSTEM_YAML_CPP" true)
      (lib.cmakeBool "RSTUDIO_DISABLE_CHECK_FOR_UPDATES" true)
      (lib.cmakeBool "QUARTO_ENABLED" true)
      (lib.cmakeBool "RSTUDIO_CRASHPAD_ENABLED" false) # This is a NOOP except on x86_64-darwin
      (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (
        (placeholder "out") + (if stdenv.isDarwin then "/Applications" else "/lib/rstudio")
      ))
    ]
    ++ lib.optionals (!server) [
      (lib.cmakeBool "RSTUDIO_INSTALL_FREEDESKTOP" stdenv.hostPlatform.isLinux)
    ];

  # on Darwin, cmake uses find_library to locate R instead of using the PATH
  env.NIX_LDFLAGS = "-L${R}/lib/R/lib";

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
    ./boost-1.86.patch
    ./fix-darwin.patch
    # needed for rebuilding for later electron versions
    ./update-nan-and-node-abi.patch
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

  npmRoot = "src/node/desktop";

  # don't build native modules with node headers
  npmFlags = [ "--ignore-scripts" ];

  npmDeps = fetchNpmDeps {
    name = "rstudio-${version}-npm-deps";
    inherit src;
    patches = [ ./update-nan-and-node-abi.patch ];
    postPatch = "cd ${npmRoot}";
    hash = "sha256-CtHCN4sWeHNDd59TV/TgTC4d6h7X1Cl4E/aJkAfRk7g=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

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

    ln -s ${quartoWrapper} dependencies/quarto

    # version in dependencies/common/install-mathjax
    ln -s ${mathJaxSrc} dependencies/mathjax-27

    mkdir -p dependencies/common/node
    # node used by cmake
    # version in CMakeGlobals.txt (RSTUDIO_NODE_VERSION)
    ln -s ${nodejs} dependencies/common/node/18.18.2
    # node used at runtime
    # version in CMakeGlobals.txt (RSTUDIO_INSTALLED_NODE_VERSION)
    ln -s ${nodejs} dependencies/common/node/18.20.3

    ${lib.optionalString (!server) ''
      pushd $npmRoot

      substituteInPlace package.json \
        --replace-fail "npm ci && " ""

      # use electron's headers to make node-gyp compile against the electron ABI
      export npm_config_nodedir="${electron-headers}"

      ### override the detected electron version
      substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
        --replace-fail "return version" "return '${electron.version}'"

      ### create the electron archive to be used by electron-packager
      cp -r ${electron.dist} electron-dist
      chmod -R u+w electron-dist

      pushd electron-dist
      zip -0Xqr ../electron.zip .
      popd

      rm -r electron-dist

      # force @electron/packager to use our electron instead of downloading it
      substituteInPlace node_modules/@electron/packager/src/index.js \
        --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron.zip'"

      # Work around known nan issue for electron_33 and above
      # https://github.com/nodejs/nan/issues/978
      substituteInPlace node_modules/nan/nan.h \
          --replace-fail '#include "nan_scriptorigin.h"' ""

      # now that we patched everything, we still have to run the scripts we ignored with --ignore-scripts
      npm rebuild

      popd
    ''}
  '';

  postInstall = ''
    mkdir -p $out/bin

    ${lib.optionalString (server && stdenv.hostPlatform.isLinux) ''
      ln -s $out/lib/rstudio/bin/{crash-handler-proxy,postback,r-ldpath,rpostback,rserver,rserver-pam,rsession,rstudio-server} $out/bin
    ''}

    ${lib.optionalString (!server && stdenv.hostPlatform.isLinux) ''
      # remove unneeded electron files, since we'll wrap the app with our own electron
      shopt -s extglob
      rm -r $out/lib/rstudio/!(locales|resources|resources.pak)

      makeWrapper ${lib.getExe electron} "$out/bin/rstudio" \
        --add-flags "$out/lib/rstudio/resources/app/" \
        --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
        --suffix PATH : ${lib.makeBinPath [ gnumake ]}

      ln -s $out/lib/rstudio/resources/app/bin/{diagnostics,rpostback} $out/bin
    ''}

    ${lib.optionalString (server && stdenv.hostPlatform.isDarwin) ''
      ln -s $out/Applications/RStudio.app/Contents/MacOS/{crash-handler-proxy,postback,r-ldpath,rpostback,rserver,rserver-pam,rsession,rstudio-server} $out/bin
    ''}

    ${lib.optionalString (!server && stdenv.hostPlatform.isDarwin) ''
      # electron can't find its files if we use a symlink here
      makeWrapper $out/Applications/RStudio.app/Contents/MacOS/RStudio $out/bin/rstudio

      ln -s $out/Applications/RStudio.app/Contents/Resources/app/bin/{diagnostics,rpostback} $out/bin
    ''}
  '';

  passthru = {
    inherit server;
    tests = {
      inherit (nixosTests) rstudio-server;
    };
  };

  meta = {
    description = "Set of integrated tools for the R language";
    homepage = "https://www.rstudio.com/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ciil
      cfhammill
      tomasajt
    ];
    mainProgram = "rstudio" + lib.optionalString server "-server";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
