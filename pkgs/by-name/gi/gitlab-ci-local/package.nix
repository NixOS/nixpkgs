{
  stdenv,
  bun,
  nodejs-slim,
  fetchFromGitHub,
  lib,
  nix-update-script,
  makeWrapper,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  rsync,
  gitMinimal,
}:

let
  pname = "gitlab-ci-local";
  version = "4.73.0";

  src = fetchFromGitHub {
    owner = "firecow";
    repo = "gitlab-ci-local";
    rev = version;
    hash = "sha256-gwjTnDc/JI645lLuaAz0gjIsBIxLFzJTMCsmrUKIz6U=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    strictDeps = true;
    __structuredAttrs = true;

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress --cpu="*" --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash = "sha256-EDGVXMyfPVoAxpMndHI3en6R6Wz/wJ9aKmuvAVg44ww=";

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    bun
    makeWrapper
    installShellFiles
  ];

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    # set version during build
    substituteInPlace package.json \
      --replace-fail "0.0.0" "${version}"

    # set a script name to avoid yargs using the script path as $0
    substituteInPlace src/index.ts \
      --replace-fail 'yargs(process.argv.slice(2))' 'yargs(process.argv.slice(2)).scriptName("gitlab-ci-local")'
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/node_modules .
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build:node

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D dist/index.js $out/lib/gitlab-ci-local/index.js

    makeWrapper ${lib.getExe nodejs-slim} $out/bin/gitlab-ci-local \
      --add-flags "$out/lib/gitlab-ci-local/index.js" \
      --prefix PATH : "${
        lib.makeBinPath [
          rsync
          gitMinimal
        ]
      }"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gitlab-ci-local \
      --bash <(SHELL=bash $out/bin/gitlab-ci-local --completion) \
      --zsh <(SHELL=zsh $out/bin/gitlab-ci-local --completion)
  ''
  + ''
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    inherit node_modules;
    updateScript = nix-update-script {
      extraArgs = [
        "--custom-dep"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "Run gitlab pipelines locally as shell executor or docker executor";
    mainProgram = "gitlab-ci-local";
    longDescription = ''
      Tired of pushing to test your .gitlab-ci.yml?
      Run gitlab pipelines locally as shell executor or docker executor.
      Get rid of all those dev specific shell scripts and make files.
    '';
    homepage = "https://github.com/firecow/gitlab-ci-local";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
}
