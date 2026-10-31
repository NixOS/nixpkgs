{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
  simpleMode ? true,
}:
buildNpmPackage (finalAttrs: {
  pname = "bentopdf";
  version = "2.8.10";

  src = fetchFromGitHub {
    owner = "alam00000";
    repo = "bentopdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BKwus1YcbaMvEfmeW296laf2s5Pbk9ZptYHes9cF754=";
  };
  npmDepsHash = "sha256-OvbcC1Hu9T5vkRecuKl6/pdxMv+lurDDJvBwo5iMFLI=";
  npmDepsFetcherVersion = 2;

  npmBuildFlags = [
    "--"
    "--mode"
    "production"
  ];

  env.SIMPLE_MODE = lib.boolToString simpleMode;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/* $out/

    runHook postInstall
  '';

  passthru = {
    tests = {
      inherit (nixosTests.bentopdf) caddy nginx;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Privacy-first PDF toolkit";
    homepage = "https://bentopdf.com";
    changelog = "https://github.com/alam00000/bentopdf/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      charludo
      stunkymonkey
    ];
  };
})
