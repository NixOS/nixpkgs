{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  nix-update-script,
  n8n,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "n8n-nodes-evolution-api";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "oriondesign2015";
    repo = "n8n-nodes-evolution-api";
    rev = "9b42ef43ba408c109666ec4e09a2e5622ad2d016";
    hash = "sha256-u9Ps+p5ZX8o65y/dxtz3nmrSXO9MS1Rk1BylzmyR8C0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-jAHeQHUPUzC4NiKl/h7i8UwStyzw2tCKs42ZkeGZVSw=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules/n8n-nodes-evolution-api
    cp -r dist package.json $out/lib/node_modules/n8n-nodes-evolution-api/
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (n8n.meta) platforms;
    description = "Evolution API hub for WhatsApp integration with n8n";
    homepage = "https://github.com/oriondesign2015/n8n-nodes-evolution-api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vitorpavani ];
  };
})
