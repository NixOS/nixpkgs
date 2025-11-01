{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  version = "1.1.1";
  pname = "bentopdf";

  src = fetchFromGitHub {
    owner = "alam00000";
    repo = "bentopdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DmD/PHMevdgaaR8Rjpw82VS3qu4n4mus0FUPGcKaeyw=";
  };
  npmDepsHash = "sha256-Z7b0Fv62PbPZaReuAc1+Sqf2Vkjs74puifQS/l+DULU=";

  npmBuildScript = "build";
  npmBuildFlags = [
    "--"
    "--mode"
    "production"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r dist/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Privacy-first PDF toolkit";
    mainProgram = "bentopdf";
    homepage = "https://bentopdf.com";
    changelog = "https://github.com/alam00000/bentopdf/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ charludo ];
  };
})
