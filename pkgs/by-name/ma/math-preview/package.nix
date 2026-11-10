{
  lib,
  nix-update-script,
  fetchFromGitLab,
  buildNpmPackage,
  nodejs,
}:

buildNpmPackage {
  pname = "math-preview";
  version = "5.1.2-unstable-2024-08-01";
  inherit nodejs;

  src = fetchFromGitLab {
    owner = "matsievskiysv";
    repo = "math-preview";
    # FIXME: switch to tag="v${finalAttrs.version}" when upstream eventually cuts a new release.
    rev = "a2ca3c175468ceaf02bab6cdfd8ef016bda2b98d";
    hash = "sha256-o7n02aecHWt4Vumj+wdv/yavaVnMuxm8p+Pb+ppDrUE=";
  };

  npmDepsHash = "sha256-IzJszTaa8NMGRadRdBetfQXJfyjVKKYveTzbPOr07Sw=";
  dontNpmBuild = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Emacs preview math inline";
    mainProgram = "math-preview";
    license = lib.licenses.gpl3Plus;
    homepage = "https://gitlab.com/matsievskiysv/math-preview";
    maintainers = with lib.maintainers; [ renesat ];
    inherit (nodejs.meta) platforms;
  };
}
