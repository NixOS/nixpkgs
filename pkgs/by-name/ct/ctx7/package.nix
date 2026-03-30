{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctx7";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    rev = "ab17551de1a3fcd088f317c01bdb000f5f3c6e21";
    hash = "sha256-nrJCYezH9VDd1Ptpg5xATx0ByweTw8dkKT2y3rnFHd8=";
  };

  postUnpack = ''
    chmod -R +w .
  '';

  postPatch = ''
    cp ${./tsup.config.ts} tsup.config.ts
  '';

  sourceRoot = "${finalAttrs.src.name}/packages/cli";

  pnpmRoot = "../..";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-8RRHfCTZVC91T1Qx+ACCo2oG4ZwMNy5WYakCjmBhe3Q=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp dist/index.js $out/bin/ctx7
    chmod +x $out/bin/ctx7
    cp package.json $out/package.json
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for managing AI coding skills and documentation context";
    homepage = "https://context7.com";
    changelog = "https://github.com/upstash/context7/releases/tag/ctx7@${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "ctx7";
    maintainers = with lib.maintainers; [ vitorpavani ];
    platforms = lib.platforms.all;
  };
})
