{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchpatch,
}:

buildNpmPackage {
  pname = "get-google-fonts";
  version = "1.2.2-unstable-2020-06-30";

  src = fetchFromGitHub {
    owner = "MrMaxie";
    repo = "get-google-fonts";
    rev = "2f8b15f6d7072533ca2ad5e0b74ccf28a313e8c8";
    hash = "sha256-LD+ur0GB2uefggQsdQRkKMwWB39HGiYYiJIrTLudcLc=";
  };

  patches = [
    # update lock file to contain all necessary information
    # https://github.com/MrMaxie/get-google-fonts/pull/27
    (fetchpatch {
      url = "https://github.com/MrMaxie/get-google-fonts/commit/f2c818fc7c9ee228db020305f432fd08eda7dc5f.patch";
      hash = "sha256-BszZdAZWpnkNETKYvSElg0lCjgcP7BNeXfMvePKAio4=";
    })
  ];

  npmDepsHash = "sha256-VUphB0Qq94rlcGrrsO2Nat/bD2IZTtdevGKsXFu/YdQ=";

  dontBuild = true;

  meta = with lib; {
    description = "Downloads and adapts Google fonts to working offline";
    mainProgram = "get-google-fonts";
    homepage = "https://github.com/MrMaxie/get-google-fonts";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
