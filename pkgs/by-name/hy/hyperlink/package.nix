{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "hyperlink";
  version = "0.1.35";

  src = fetchFromGitHub {
    owner = "untitaker";
    repo = "hyperlink";
    rev = version;
    hash = "sha256-sx1OW056s40uhwwgGtNKiPkKSUy7/ZzSYGnjc0UKh/E=";
  };

  cargoHash = "sha256-2/i+YllfS1ZC+nzmjBMJLjcq6Q+upFX2Wc+jmBO4zp0=";

  meta = with lib; {
    description = "Very fast link checker for CI";
    homepage = "https://github.com/untitaker/hyperlink";
    license = licenses.mit;
    maintainers = with maintainers; [ samueltardieu ];
    mainProgram = "hyperlink";
  };
}
