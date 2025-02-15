{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "foxmarks";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "zer0-x";
    repo = "foxmarks";
    rev = "v${version}";
    hash = "sha256-tkmmu6A7vqK4yO9zHjVEeACaOHP3+hJQLBK7p/Svn7Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/B8T5OZMKQIj92PWWehzkO3iiI/lr5gl6jwXeglN9EU=";

  buildInputs = [ sqlite ];

  meta = {
    description = "CLI read-only interface for Mozilla Firefox's bookmarks";
    homepage = "https://github.com/zer0-x/foxmarks";
    changelog = "https://github.com/zer0-x/foxmarks/blobl/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ loicreynier ];
  };
}
