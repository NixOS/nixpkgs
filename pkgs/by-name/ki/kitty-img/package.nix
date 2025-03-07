{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage rec {
  pname = "kitty-img";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "kitty-img";
    rev = version;
    hash = "sha256-5thx4ADmJE29bxN+ZO3hF0jhgXK+boqt8oj4Sygl5SU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KSNl/SpqcgMaKbkBfNtR7M8+B1clPauYi7NlP+f5Pd0=";

  meta = with lib; {
    description = "Print images inline in kitty";
    homepage = "https://git.sr.ht/~zethra/kitty-img";
    changelog = "https://git.sr.ht/~zethra/kitty-img/refs/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gaykitty ];
    mainProgram = "kitty-img";
  };
}
