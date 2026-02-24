{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # TODO fix once upstream uses semver for tags again
    tag = "mdbook-i18n-helpers-${version}";
    hash = "sha256-q1Bpj0R4AkGbmAkCKtmF8X/LCxxeDJp+719xKZld6rs=";
  };

  cargoHash = "sha256-zxh4Wa8JngQfUYQsxEpdb+cO3zqNpt2TkesGVxqDnjs=";

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
