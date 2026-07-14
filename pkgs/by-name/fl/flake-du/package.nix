{
  lib,
  rustPlatform,
  fetchgit,
}:
let
  version = "0.1.0";
in
rustPlatform.buildRustPackage {
  pname = "flake-du";
  inherit version;

  src = fetchgit {
    url = "https://github.com/kmein/flake-du";
    rev = "v${version}";
    sha256 = "sha256-+YfQRi6QE4xNUcIcEc9HWIbnin6GCVp4SYrjvBwksys=";
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
