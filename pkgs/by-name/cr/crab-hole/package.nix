{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "crab-hole";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "LuckyTurtleDev";
    repo = "crab-hole";
    rev = "refs/tags/v${version}";
    hash = "sha256-OyZ+GkWU+OMnS6X7yk7H1e1MzfQQQkhOkoxUmWn6k7I=";
  };

  cargoHash = "sha256-NeVCGN2ZIyrufa3geO8bbwV7ncenguftnr5SClRZLi8=";

  meta = {
    description = "Pi-Hole clone written in Rust using Hickory DNS";
    homepage = "https://github.com/LuckyTurtleDev/crab-hole";
    license = lib.licenses.agpl3Plus;
    mainProgram = "crab-hole";
    maintainers = [
      lib.maintainers.NiklasVousten
    ];
    platforms = lib.platforms.linux;
  };
}
