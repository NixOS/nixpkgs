{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  clang_16,
  testers,
  nixel,
}:
let
  clang = clang_16; # Until bindgen is updated with clang19 support
  rustPlatform' = rustPlatform // {
    bindgenHook = rustPlatform.bindgenHook.override { inherit clang; };
  };
in
rustPlatform'.buildRustPackage rec {
  pname = "nixel";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = pname;
    rev = version;
    sha256 = "sha256-wIXZd8iujLqbgbV+abWmIfjDgQ8i6nyE5jTAs3OczXM=";
  };

  cargoHash = "sha256-GJ2UO8MvujRxFjzdt2Tfrlfzv1jot9XCrmfBqTFVngI=";

  nativeBuildInputs = [
    # Workaround borrowed here where the same error were observed: https://github.com/NixOS/nixpkgs/issues/331240#issuecomment-2260565324
    rustPlatform'.bindgenHook # with override { clang = clang_16; }
  ];

  # Package requires a non reproducible submodule
  # https://github.com/kamadorueda/nixel/blob/2873bd84bf4fc540d0ae8af062e109cc9ad40454/.gitmodules#L7
  doCheck = false;
  #
  # Let's test it runs
  passthru.tests = {
    version = testers.testVersion { package = nixel; };
  };
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Lexer, Parser, Abstract Syntax Tree and Concrete Syntax Tree for the Nix Expressions Language";
    mainProgram = "nixel";
    homepage = "https://github.com/kamadorueda/nixel";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
