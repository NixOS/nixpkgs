{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm,
  nodejs,
  pnpmConfigHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "slidev-cli";
  version = "52.11.1";

  src = fetchFromGitHub {
    owner = "slidevjs";
    repo = "slidev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AYU36NsALC4CCZVr+1PmspX6RKZkxI2xpLNUSccEPwY=";
  };

  pnpmWorkspaces = [ "@slidev/cli..." ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 3;
    hash = "sha256-nZPyqP4NruVIzONHIT6hx1Px9p8mHTK9Xt5wHEcpwBM=";
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
