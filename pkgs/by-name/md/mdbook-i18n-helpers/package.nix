{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # TODO fix once upstream uses semver for tags again
    rev = "refs/tags/mdbook-i18n-helpers-${version}";
    hash = "sha256-FdguzuYpMl6i1dvoPNE1Bk+GTmeTrqLUY/sVRsbETtU=";
  };

  cargoHash = "sha256-sPRylKXTSkVkhDvpAvHuYIr9TSi1ustIs1HTwEIbk/w=";

  meta = with lib; {
    description = "Helpers for a mdbook i18n workflow based on Gettext";
    homepage = "https://github.com/google/mdbook-i18n-helpers";
    changelog = "https://github.com/google/mdbook-i18n-helpers/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ teutat3s matthiasbeyer ];
  };
}
