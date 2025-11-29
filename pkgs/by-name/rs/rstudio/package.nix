{
  lib,
  stdenv,

  server ? false, # build server version

  fetchFromGitHub,
  fetchNpmDeps,
  fetchYarnDeps,
  fetchzip,
  replaceVars,
  runCommand,

  ant,
  cacert,
  cmake,
  git,
  jdk,
  makeWrapper,
  nodejs,
  npmHooks,
  xcbuild,
  yarn,
  yarnConfigHook,
  zip,

  boost187,
  electron_37,
  fontconfig,
  gnumake,
  hunspellDicts,
  libuuid,
  llvmPackages,
  openssl,
  pam,
  pandoc,
  quarto,
  R,
  soci,
  sqlite,
  zlib,

  nixosTests,
}:

let
  electron = electron_37;

  mathJaxSrc = fetchzip {
    url = "https://s3.amazonaws.com/rstudio-buildtools/mathjax-27.zip";
    hash = "sha256-J7SZK/9q3HcXTD7WFHxvh++ttuCd89Vc4SEBrUEU0AI=";
  };

  # Note: we could build this from source, but let's just do what upstream does for now
  gwt = fetchzip {
    url = "https://rstudio-buildtools.s3.us-east-1.amazonaws.com/gwt/gwt-2.12.2.tar.gz";
    stripRoot = false;
    hash = "sha256-DgcCiheYeP7sISduz6E3WhTty2nSs14k2OYIG93KmkY=";
  };

  quartoSrc = fetchFromGitHub {
    owner = "quarto-dev";
    repo = "quarto";
    # Note: rev should ideally be the last commit of the release/rstudio-[codename] branch
    # Note: This is the last working revision, because https://github.com/quarto-dev/quarto/pull/757
    #       started using `file:` in the lockfile, which our fetcher can't handle
    rev = "faef822a085df65809adf55fb77c273e9cdb87b9";
    hash = "sha256-DLpVYl0OkaBQtkFinJAS2suZ8gqx9BVS5HBaYrrT1HA=";
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
  version = "2025.09.2+418";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rstudio";
    tag = "v${version}";
    hash = "sha256-UFhvNLamKZQ9IBjEtDvSPOUILqGphDDOVb7ZZ8dnfVU=";
  };

  # sources fetched into _deps via cmake's FetchContent
  extSrcs = stdenv.mkDerivation {
    name = "${pname}-${version}-ext-srcs";
    inherit src;

    nativeBuildInputs = [
      cacert
      cmake
      git
    ];

    installPhase = ''
      runHook preInstall

      # this will fail, since this is not meant to be a cmake entrypoint
      # but it will fetch the dependencies regardless
      cmake -S src/cpp/ext -B build || true

      mkdir -p "$out"
      cp -r build/_deps/*-src "$out/"
      find "$out" -name .git -print0 | xargs -0 rm -rf

      runHook postInstall
    '';

    dontConfigure = true;
    dontBuild = true;
    dontFixup = true;

    outputHash = "sha256-pXpp42hjjKrV75f2XLDYK7A9lrvWhuQBDJ0oymXE8Fg=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    cmake
    git

    ant
    jdk

    nodejs
    yarn
    yarnConfigHook
    zip
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
  ]
  ++ lib.optionals (!server) [
    makeWrapper
    (nodejs.python.withPackages (ps: [ ps.setuptools ]))
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    boost187
    libuuid
    openssl
    R
    soci
    sqlite.dev
  ]
  ++ lib.optionals (!server) [
    fontconfig
  ]
  ++ lib.optionals server [
    pam
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "RSTUDIO_TARGET" (if server then "Server" else "Electron"))

    # don't try fetching the external dependencies already fetched in extSrcs
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)

    (lib.cmakeBool "RSTUDIO_USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "RSTUDIO_USE_SYSTEM_SOCI" true)

    (lib.cmakeBool "RSTUDIO_DISABLE_CHECK_FOR_UPDATES" true)
    (lib.cmakeBool "QUARTO_ENABLED" true)
    (lib.cmakeBool "RSTUDIO_ENABLE_COPILOT" false) # copilot-language-server is unfree
    (lib.cmakeBool "RSTUDIO_CRASHPAD_ENABLED" false) # This is a NOOP except on x86_64-darwin

    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" (
      (placeholder "out") + (if stdenv.hostPlatform.isDarwin then "/Applications" else "/lib/rstudio")
    ))
  ]
  ++ lib.optionals (!server) [
    (lib.cmakeBool "RSTUDIO_INSTALL_FREEDESKTOP" stdenv.hostPlatform.isLinux)
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # on Darwin, cmake uses find_library to locate R instead of using the PATH
    NIX_LDFLAGS = "-L${R}/lib/R/lib";

    RSTUDIO_VERSION_MAJOR = lib.versions.major version;
    RSTUDIO_VERSION_MINOR = lib.versions.minor version;
    RSTUDIO_VERSION_PATCH = lib.versions.patch version;
    RSTUDIO_VERSION_SUFFIX = "+" + toString (lib.tail (lib.splitString "+" version));
  };

  patches = [
    # Hack RStudio to only use the input R and provided libclang.
    (replaceVars ./r-location.patch {
      R = lib.getBin R;
    })
    (replaceVars ./clang-location.patch {
      libclang = lib.getLib llvmPackages.libclang;
    })

    ./ignore-etc-os-release.patch
    ./dont-yarn-install.patch
    ./dont-npm-ci.patch
    ./fix-darwin.patch
  ];

  postPatch = ''
    # fix .desktop Exec field
    substituteInPlace src/node/desktop/resources/freedesktop/rstudio.desktop.in \
      --replace-fail "\''${CMAKE_INSTALL_PREFIX}/rstudio" "rstudio"

    # set install path of freedesktop files
    substituteInPlace src/node/desktop/CMakeLists.txt \
      --replace-fail "/usr/share" "$out/share"
  '';

  yarnOfflineCache = fetchYarnDeps {
    src = quartoSrc;
    hash = "sha256-9ObJ3fzxPyGVfIgBj4BhCWqkrG1A2JqZsCreJA+1fWQ=";
  };

  dontYarnInstallDeps = true; # will call manually in preConfigure

  npmRoot = "src/node/desktop";

  # don't build native modules with node headers
  npmFlags = [ "--ignore-scripts" ];

  makeCacheWritable = true;

  npmDeps = fetchNpmDeps {
    name = "rstudio-${version}-npm-deps";
    inherit src;
    postPatch = "cd ${npmRoot}";
    hash = "sha256-/5GgRusDRyBMr5581ypTMzhqkvjpzYBaniFos524bEw=";
  };

  preConfigure = ''
    # populate the directories used by cmake's FetchContent
    mkdir -p build/_deps
    cp -r "$extSrcs"/* build/_deps
    chmod -R u+w build/_deps

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

    ln -s ${gwt} dependencies/common/gwtproject

    ln -s ${quartoWrapper} dependencies/quarto

    # version in dependencies/common/install-mathjax
    ln -s ${mathJaxSrc} dependencies/mathjax-27

    mkdir -p dependencies/common/node
    # node used by cmake
    # version in cmake/globals.cmake (RSTUDIO_NODE_VERSION)
    ln -s ${nodejs} dependencies/common/node/22.13.1

  ''
  + lib.optionalString (!server) ''
    pushd $npmRoot

    # use electron's headers to make node-gyp compile against the electron ABI
    export npm_config_nodedir="${electron.headers}"

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
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron.zip'"

    # Work around known nan issue for electron_33 and above
    # https://github.com/nodejs/nan/issues/978
    substituteInPlace node_modules/nan/nan.h \
      --replace-fail '#include "nan_scriptorigin.h"' ""

    # now that we patched everything, we still have to run the scripts we ignored with --ignore-scripts
    npm rebuild

    popd
  '';

  postInstall = ''
    mkdir -p $out/bin
  ''
  + lib.optionalString (server && stdenv.hostPlatform.isLinux) ''
    ln -s $out/lib/rstudio/bin/{crash-handler-proxy,postback,r-ldpath,rpostback,rserver,rserver-pam,rsession,rstudio-server} $out/bin
  ''
  + lib.optionalString (!server && stdenv.hostPlatform.isLinux) ''
    # remove unneeded electron files, since we'll wrap the app with our own electron
    shopt -s extglob
    rm -r $out/lib/rstudio/!(locales|resources|resources.pak)

    makeWrapper ${lib.getExe electron} "$out/bin/rstudio" \
      --add-flags "$out/lib/rstudio/resources/app/" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --suffix PATH : ${lib.makeBinPath [ gnumake ]}

    ln -s $out/lib/rstudio/resources/app/bin/{diagnostics,rpostback} $out/bin
  ''
  + lib.optionalString (server && stdenv.hostPlatform.isDarwin) ''
    ln -s $out/Applications/RStudio.app/Contents/MacOS/{crash-handler-proxy,postback,r-ldpath,rpostback,rserver,rserver-pam,rsession,rstudio-server} $out/bin
  ''
  + lib.optionalString (!server && stdenv.hostPlatform.isDarwin) ''
    # electron can't find its files if we use a symlink here
    makeWrapper $out/Applications/RStudio.app/Contents/MacOS/RStudio $out/bin/rstudio

    ln -s $out/Applications/RStudio.app/Contents/Resources/app/bin/{diagnostics,rpostback} $out/bin
  '';

  passthru = {
    inherit server;
    tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit (nixosTests) rstudio-server;
    };
  };

  meta = {
    changelog = "https://github.com/rstudio/rstudio/tree/${src.rev}/version/news";
    description = "Set of integrated tools for the R language";
    homepage = "https://www.rstudio.com/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ciil
      cfhammill
      tomasajt
    ];
    mainProgram = "rstudio" + lib.optionalString server "-server";
    # rstudio-server on darwin is only partially supported by upstream
    platforms = lib.platforms.linux ++ lib.optionals (!server) lib.platforms.darwin;
  };
}
