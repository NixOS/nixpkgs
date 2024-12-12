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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GJHxo4WD/XMudwxOHdNwY1M+b/DFJMpU0uD3sOvO5YU=";
  };

  cargoHash = "sha256-T+Sdzts7gzkG2EFcKrkVDUIq2V34PBdW3oyxMUcCWaI=";

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Cross platform, fast, compression and decompression tool";
    homepage = "https://github.com/sstadick/crabz";
    changelog = "https://github.com/sstadick/crabz/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      unlicense # or
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "crabz";
  };
}
