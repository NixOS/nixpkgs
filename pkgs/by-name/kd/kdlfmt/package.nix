{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kdlfmt";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hougesen";
    repo = "kdlfmt";
    rev = "v${version}";
    hash = "sha256-XiSHqiYmnU8fKhfXcZlUl/KL2ws9SYTiBXODgY7RIc8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YLaP4kUgf5GvDZMBn3UCt3/w/t3mUhDEQwrKzUV1Kd8=";

  meta = {
    description = "Formatter for kdl documents";
    homepage = "https://github.com/hougesen/kdlfmt.git";
    changelog = "https://github.com/hougesen/kdlfmt/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    mainProgram = "kdlfmt";
  };
}
