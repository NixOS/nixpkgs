{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "colo";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Aloso";
    repo = "colo";
    tag = "v${version}";
    hash = "sha256-ocGzZR4gM2sInXccbHxh7Vf0kcZTZOnVW0KM6zp/pR8=";
  };

  cargoHash = "sha256-bAq1sDP/EG9TuUHHWLrp3JtW6S5nWgyyXQbiD63WPGk=";

  meta = {
    description = "Displays colors in various color spaces";
    homepage = "https://aloso.github.io/colo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ llakala ];
  };
}
