{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
  makeWrapper,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  versionCheckHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "concurrently";
  version = "9.2.1";
=======
  fetchpatch2,
  makeWrapper,
  nodejs,
  pnpm_8,
}:

let
  pnpm = pnpm_8;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "concurrently";
  version = "8.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "open-cli-tools";
    repo = "concurrently";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-PKbrYgQ6D0vxMSxx+aHBo09NJZh5YYfb9Fx9L5Ue8vM=";
  };

  pnpmDeps = fetchPnpmDeps {
=======
    hash = "sha256-VoyVYBOBMguFKnG2VItk1L5BbF72nO7bYJpb7adqICs=";
  };

  pnpmDeps = pnpm.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (finalAttrs)
      pname
      version
      src
<<<<<<< HEAD
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-UVsmOneTICl3Ybmv7ebebkXmr1qwNh17dPhL0qlPgyg=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_10
=======
      patches
      ;
    fetcherVersion = 1;
    hash = "sha256-F1teWIABkK0mqZcK3RdGNKmexI/C59QWSrrD1jYbHt0=";
  };

  patches = [
    (fetchpatch2 {
      name = "use-pnpm-8.patch";
      url = "https://github.com/open-cli-tools/concurrently/commit/0b67a1a5a335396340f4347886fb9d0968a57555.patch";
      hash = "sha256-mxid2Yl9S6+mpN7OLUCrJ1vS0bQ/UwNiGJ0DL6Zn//Q=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

<<<<<<< HEAD
  preInstall = ''
    # remove unnecessary files
    CI=true pnpm --ignore-scripts --prod prune
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete

    # remove non-deterministic files
    rm node_modules/{.modules.yaml,.pnpm-workspace-state-v1.json}
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/concurrently"
    cp -r dist node_modules "$out/lib/concurrently"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/concurrently" \
      --add-flags "$out/lib/concurrently/dist/bin/concurrently.js"
    ln -s "$out/bin/concurrently" "$out/bin/con"
<<<<<<< HEAD
    cp package.json "$out/lib/concurrently/"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    runHook postInstall
  '';

<<<<<<< HEAD
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    changelog = "https://github.com/open-cli-tools/concurrently/releases/tag/v${finalAttrs.version}";
    description = "Run commands concurrently";
    homepage = "https://github.com/open-cli-tools/concurrently";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jpetrucciani ];
    mainProgram = "concurrently";
  };
})
