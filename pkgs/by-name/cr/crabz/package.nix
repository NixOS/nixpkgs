{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "crabz";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "crabz";
    rev = "v${version}";
    sha256 = "sha256-GJHxo4WD/XMudwxOHdNwY1M+b/DFJMpU0uD3sOvO5YU=";
  };

  cargoHash = "sha256-JzzDkbDVL6az6b/s640KikSNJCwv8hf0aFcmGnvYQu4=";

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Cross platform, fast, compression and decompression tool";
    homepage = "https://github.com/sstadick/crabz";
    changelog = "https://github.com/sstadick/crabz/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      unlicense # or
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "crabz";
  };
}
