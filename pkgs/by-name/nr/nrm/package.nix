{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  makeBinaryWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nrm";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "pana";
    repo = "nrm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2P0dSZa17A3NslNatCx1edLnrcDtGGpOlk6srcvjL1Y=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeBinaryWrapper
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-PENYS5xO2LwT3+TGl/wU2r0ALEj/JQfbkpf/0MJs0uw=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/nrm
    mkdir $out/bin
    mv * $out/lib/node_modules/nrm/
    makeWrapper ${lib.getExe nodejs} $out/bin/nrm \
      --add-flags "$out/lib/node_modules/nrm/dist/index.js" \
      --set "NODE_PATH" "$out/lib/node_modules/nrm/node_modules"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Pana/nrm/releases/tag/v${finalAttrs.version}";
    description = "Helps you switch between npm registries easily";
    homepage = "https://github.com/Pana/nrm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "nrm";
  };
})
