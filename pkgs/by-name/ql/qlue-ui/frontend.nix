{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "qlue-ui-frontend";
  version = "0-unstable-2026-11-07";

  src = fetchFromGitHub {
    owner = "qlever-dev";
    repo = "qlue-ui";
    rev = "0cf882c7de7d4a5b0a567e5cbcc7e3ab85a8bc1d";
    hash = "sha256-3r3pmmo8nfGmVlTRFT8fOwDkjd/rkW7xCxhQocBqdzw=";
  };

  sourceRoot = "${finalAttrs.src.name}/frontend";

  npmDepsHash = "sha256-V6yyVbF2xrUWGP6XMNQGN5iBcKTAGfV0s9fBoe8dB1w=";

  __structuredAttrs = true;

  env.VITE_GIT_COMMIT = builtins.substring 0 7 finalAttrs.src.rev;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist/* $out/
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Frontend for QLUE UI";
    homepage = "https://github.com/qlever-dev/qlue-ui";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ ngi ];
  };
})
