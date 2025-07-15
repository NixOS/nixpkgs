{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # TODO fix once upstream uses semver for tags again
    tag = "mdbook-i18n-helpers-${version}";
    hash = "sha256-FdguzuYpMl6i1dvoPNE1Bk+GTmeTrqLUY/sVRsbETtU=";
  };

  cargoHash = "sha256-ZBGMfJA2diPvvoIXPosUs4ngXU9/GMGa4GAlKIjwm8s=";

  meta = {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      teutat3s
      matthiasbeyer
    ];
  };
}
