{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-i18n-helpers";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mdbook-i18n-helpers";
    # TODO fix once upstream uses semver for tags again
    tag = "mdbook-i18n-helpers-${version}";
    hash = "sha256-9sJ9FK85UzY3ggh3h1fipbh0LraTvQJ0ZfhSGcahiDM=";
  };

  cargoHash = "sha256-ZinW9UFp03LXtk+9vuSNojVZtaA7uBlrpdapY48nZdY=";

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
