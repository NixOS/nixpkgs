{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  nodejs,
  pnpmConfigHook,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "slidev-cli";
  version = "52.15.1";

  src = fetchFromGitHub {
    owner = "slidevjs";
    repo = "slidev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2SksaDC/OC53ZGyraS/WzySSbPEnlzdURGInZ2neQwU=";
  };

  pnpmWorkspaces = [ "@slidev/cli..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-DGDzNvau1XjPjkGZqcFZGkjYd3cneXO/gCdnwjjkQDY=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildInputs = [
    nodejs
  ];

  buildPhase = ''
    runHook preBuild

    pnpm -r --filter=@slidev/cli... --parallel run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf node_modules packages/slidev/node_modules
    pnpm install --force --offline --production --ignore-scripts --filter=@slidev/cli...

    mkdir -p $out/lib/node_modules/slidev-cli/
    mkdir $out/bin
    mv ./packages ./node_modules ./package.json $out/lib/node_modules/slidev-cli

    ln -s $out/lib/node_modules/slidev-cli/packages/slidev/bin/slidev.mjs $out/bin/slidev
    chmod +x $out/bin/slidev
    patchShebangs $out/bin/slidev

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/slidevjs/slidev/releases/tag/v${finalAttrs.version}";
    description = "Presentation slides for developers";
    homepage = "https://sli.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pyrox0
      pluiedev
    ];
    mainProgram = "slidev";
  };
})
