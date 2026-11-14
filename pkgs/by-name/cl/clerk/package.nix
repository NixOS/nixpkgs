{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  pname = "clerk";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "clerk";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-CLZ7h67ltIgFbdd3ltfx20fvLjDIVPqCWIKvdI7rUIA=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R node_modules $out
      find packages -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-qi9+OX5qoPRQ7t4S/XBDhhZvcj7+BW6LupVmkZn5oZI=";
    outputHashMode = "recursive";
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    bun
    installShellFiles
    writableTmpDirAsHomeHook
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/. .
    chmod -R u+w node_modules
    find packages -type d -name node_modules -exec chmod -R u+w {} + 2>/dev/null || true

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p .bun-tmp .bun-install
    BUN_TMPDIR=$PWD/.bun-tmp \
    BUN_INSTALL=$PWD/.bun-install \
      bun build --compile \
        --target=bun \
        --minify \
        --no-compile-autoload-dotenv \
        --no-compile-autoload-bunfig \
        --define CLI_VERSION='"${finalAttrs.version}"' \
        ./packages/cli-core/src/cli.ts \
        --outfile clerk

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 clerk $out/bin/clerk

    installShellCompletion --cmd clerk \
      --bash <($out/bin/clerk completion bash) \
      --zsh <($out/bin/clerk completion zsh) \
      --fish <($out/bin/clerk completion fish)

    runHook postInstall
  '';

  dontStrip = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    inherit node_modules;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "The official Clerk CLI";
    homepage = "https://clerk.com/docs";
    changelog = "https://github.com/clerk/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "clerk";
    maintainers = with lib.maintainers; [ sha1000 ];
    platforms = bun.meta.platforms;
  };
})
