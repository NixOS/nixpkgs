{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
  simpleMode ? true,
}:
buildNpmPackage (finalAttrs: {
  version = "1.11.2";
  pname = "bentopdf";

  src = fetchFromGitHub {
    owner = "alam00000";
    repo = "bentopdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-br4My0Q4zoA+ZIrXM4o4oQjZ7IpSdwg+iKiAUdc2B/s=";
  };
  npmDepsHash = "sha256-UNNNYO7e7qdumI0/ka2ieFZzKURPl1V3981vHCPcVfY=";

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

  passthru.tests = {
    inherit (nixosTests.bentopdf) caddy nginx;
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
