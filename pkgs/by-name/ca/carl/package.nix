{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "carl";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "b1rger";
    repo = "carl";
    rev = "v${version}";
    hash = "sha256-4k08iwuZjnsd2EjqnslrJa3ugPOgUvUzbY3/9mxegkQ=";
  };

  doCheck = false;

  cargoHash = "sha256-1tqg/VJfgf7Y/5yM+iKYd7Vn2YCnH7RwmVPb+aO9KxY=";

  meta = {
    description = "cal(1) with more features and written in rust";
    longDescription = ''
      Carl is a calendar for the commandline. It tries to mimic the various cal(1)
      implementations out there, but also adds enhanced features like colors and ical
      support
    '';
    homepage = "https://github.com/b1rger/carl";
    changelog = "https://github.com/b1rger/carl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "carl";
  };
}
