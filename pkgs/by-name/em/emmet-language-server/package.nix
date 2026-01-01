{
  lib,
  stdenvNoCC,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
=======
  fetchFromGitHub,
  nix-update-script,
}:

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "emmet-language-server";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "olrtg";
    repo = "emmet-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EY/xfrf6sGnZPbkbf9msauOoZ0h0EjLSwQC0aiS/Kco=";
  };

<<<<<<< HEAD
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
=======
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetcherVersion = 1;
    hash = "sha256-sMOC5MQmJKwXZoUZnOmBy2I83SNMdrPc6WQKmeVGiCc=";
  };

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm_9
=======
    pnpm_9.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildPhase = ''
    runHook preBuild

    # TODO: use deploy after resolved https://github.com/pnpm/pnpm/issues/5315
    pnpm build

    runHook postBuild
  '';

  # remove unnecessary and non-deterministic files
  preInstall = ''
    CI=true pnpm --ignore-scripts --prod prune
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete

    rm node_modules/.modules.yaml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/emmet-language-server}
    mv {node_modules,dist} $out/lib/emmet-language-server

    chmod +x $out/lib/emmet-language-server/dist/index.js
    patchShebangs $out/lib/emmet-language-server/dist/index.js
    ln -s $out/lib/emmet-language-server/dist/index.js $out/bin/emmet-language-server

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for emmet.io";
    homepage = "https://github.com/olrtg/emmet-language-server";
    changelog = "https://github.com/olrtg/emmet-language-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gepbird
    ];
    mainProgram = "emmet-language-server";
  };
})
