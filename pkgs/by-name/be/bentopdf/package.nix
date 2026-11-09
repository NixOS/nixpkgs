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
  version = "2.8.11";

  src = fetchFromGitHub {
    owner = "alam00000";
    repo = "bentopdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZhG2nkRJt5qMEHhYRyh5wmqS5oKn4f1HX/3Bt6xyJy8=";
  };
  npmDepsHash = "sha256-tN6ky6c1WXKXEgb9Gx1mB+9UpjEPlBXcvqXdDgXOkG4=";
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
