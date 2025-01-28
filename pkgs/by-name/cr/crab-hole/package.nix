{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "crab-hole";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "LuckyTurtleDev";
    repo = "crab-hole";
    tag = "v${version}";
    hash = "sha256-HJQpzUdvjGhZnH5+qlgaekDpqSUmOhR30VPzg1lZIl0=";
  };

  cargoHash = "sha256-6g5l4sQv8OsOLJZ/Vl3RLU8k/zx3Bj13STonsY2+lf0=";

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
