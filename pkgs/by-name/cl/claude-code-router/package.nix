{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

let
  src = fetchFromGitHub {
    owner = "musistudio";
    repo = "claude-code-router";
    rev = "6ab608943e8e49dc7bdffe14611416c7de32823d";
    hash = "sha256-GM4tjlWIhmNkkrNKqS619MYkTSsvs1Zmj/uLxdFdWjQ=";
  };

  version = "1.0.43";

  # Build the UI separately
  claude-code-router-ui = buildNpmPackage {
    pname = "claude-code-router-ui";
    inherit version;
    inherit src;

    sourceRoot = "source/ui"; # Point to the ui subdirectory

    npmDepsHash = "sha256-csEQdnbPcWtBxBu8Jv1bL1ArcZ3ikw0kZ+RdRnEEihs=";

    installPhase = ''
      runHook preInstall

      # Copy only the built artifacts
      mkdir -p $out
      cp -r dist/* $out/

      runHook postInstall
    '';
  };
in
buildNpmPackage rec {
  pname = "claude-code-router";
  inherit version;
  inherit src;

  npmDepsHash = "sha256-6vdn/Aa10+61pCVLhTjcmtS4+DaHKSK6vycHPpgvST0=";

  patches = [ ./ui-build.patch ];

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  postBuild = ''
    cp -i ${claude-code-router-ui}/* dist/
  '';

  meta = {
    description = "Route Claude Code requests to different models and customize any request";
    homepage = "https://github.com/musistudio/claude-code-router";
    downloadPage = "https://www.npmjs.com/package/@musistudio/claude-code-router";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      graham33
    ];
    mainProgram = "claude-code-router";
  };
}
