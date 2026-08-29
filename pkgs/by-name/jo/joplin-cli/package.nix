{
  lib,
  stdenv,
  nodejs,
  fetchFromGitHub,
  substitute,
  yarn-berry_4,
  python3,
  pkg-config,
  libsecret,
  rsync,
  xcbuild,
  buildPackages,
  clang_20,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "joplin-cli";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "laurent22";
    repo = "joplin";
    tag = "v${finalAttrs.version}";
    postFetch = ''
      # there's a file with a weird name that causes a hash mismatch on darwin
      rm $out/packages/app-cli/tests/support/photo*

      # Remove when updating since upstream has updated Yarn
      # https://github.com/laurent22/joplin/commit/071f205c44da8e2979dcf53a4105648bfa0e7f83
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
    hash = "sha256-LSkiW3Kwtjsk2LLM/MXo6ErR+G8b7IX3LkEtDJlc7ok=";
  };

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs)
      src
      missingHashes
      postPatch
      ;
    hash = "sha256-EHHAB20syDakpN4TGuLCc1v2AGEJPc3y7uCpS+PVzzQ=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_4.yarn-berry-offline
    yarn-berry_4.yarnBerryConfigHook
    (python3.withPackages (ps: with ps; [ distutils ]))
    pkg-config
    libsecret
    rsync
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    buildPackages.cctools
    clang_20 # clang_21 breaks keytar, sqlite
  ];

  buildInputs = [
    nodejs
  ];

  env = {
    # Disable scripts so that yarn doesn't immediately run them
    # We want to patch them first
    YARN_ENABLE_SCRIPTS = 0;
  };

  postPatch = ''
    # Don't immediately build everything
    sed -i '/postinstall/d' package.json
    # Don't install onenote-converter subpackage deps
    sed -i '/onenote-converter/d' packages/{lib,app-cli}/package.json
  '';

  buildPhase = ''
    runHook preBuild

    unset YARN_ENABLE_SCRIPTS

    yarn config set enableInlineBuilds true

    for node_modules in packages/*/node_modules; do
      patchShebangs $node_modules
    done

    yarn workspaces focus root joplin
    yarn workspaces foreach -Rptvi --from joplin run tsc
    yarn workspaces foreach -Rtvi --from joplin run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Remove dev dependencies
    yarn workspaces focus --production root joplin

    mkdir -p $out/lib/packages
    mkdir $out/bin
    mv packages/{app-cli,renderer,tools,utils,lib,htmlpack,turndown{,-plugin-gfm},fork-*} $out/lib/packages/
    rm -rf $out/lib/packages/lib/node_modules/canvas

    # Remove extra files
    rm -rf $out/lib/packages/app-cli/{app/*.test.ts,*.md,.*ignore,tests/,tools/,*.js,*.json,*.sh}

    # Link final binary
    chmod +x $out/lib/packages/app-cli/app/main.js
    ln -s $out/lib/packages/app-cli/app/main.js $out/bin/joplin
    patchShebangs $out/bin/joplin

    runHook postInstall
  '';

  updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/laurent22/joplin/releases/v${finalAttrs.version}";
    description = "CLI client for Joplin";
    homepage = "https://joplinapp.org/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "joplin";
    maintainers = [ ];
  };
})
