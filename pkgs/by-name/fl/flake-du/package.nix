{
  lib,
  rustPlatform,
  fetchgit,
}:
let
  version = "0.2.0";
in
rustPlatform.buildRustPackage {
  pname = "flake-du";
  inherit version;

  src = fetchgit {
    url = "https://github.com/kmein/flake-du";
    rev = "v${version}";
    hash = "sha256-mwSZvAEs4RKzIKErnxPhK7J7yhqo1ibDRy0FXoKlsHY=";
  };

  cargoHash = "sha256-DYVT9jM9WcgoVSOnoUIWWR9EmNywR1f4xZOAzkbNkCk=";

  __structuredAttrs = true;

  meta = {
    description = "Tool for managing flake inputs with disk usage insights";
    license = lib.licenses.mit;
    homepage = "https://github.com/kmein/flake-du";
    maintainers = [ lib.maintainers.kmein ];
  };
}
