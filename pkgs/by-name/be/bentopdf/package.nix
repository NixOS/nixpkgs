{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  version = "1.7.9";
  pname = "bentopdf";

  src = fetchFromGitHub {
    owner = "alam00000";
    repo = "bentopdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vSwjQWwxjYMjFIt30BqwaMo4M9hrjFLTNVwtObwOHkI=";
  };
  npmDepsHash = "sha256-rGafLfp+RzR8x8iFIDactIv+bVPEo9XH0l0eJc31JkE=";

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
