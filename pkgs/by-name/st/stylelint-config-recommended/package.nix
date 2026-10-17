{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
}:
buildNpmPackage rec {
  pname = "stylelint-config-recommended";
  version = "18.0.0";

  src = fetchFromGitHub {
    owner = "stylelint";
    repo = "stylelint-config-recommended";
    tag = version;
    hash = "sha256-bwWPP5uVRQCqNd5SU4P0pXuqx7M/ccwSLaXTfxNb/Cg=";
  };

  npmDepsHash = "sha256-7DTZX95SWlYGyScerTzQjOcl/PcneoS/FxypAaLgY+s=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  __structuredAtts = true;

  meta = {
    description = "Recommended shareable config for Stylelint";
    mainProgram = "stylelint";
    homepage = "https://github.com/stylelint/stylelint-config-recommended";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mib ];
  };
}
