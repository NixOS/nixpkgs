{
  lib,
  fetchpatch,
  stdenv,
  fetchFromGitHub,
  cmake,
  gitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "fatcat";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Gregwar";
    repo = "fatcat";
    rev = "v${version}";
    hash = "sha256-/iGNVP7Bz/UZAR+dFxAKMKM9jm07h0x0F3VGpdxlHdk=";
  };

  patches = [
    # cmake: Set minimum required version to 3.5 for CMake 4+
    (fetchpatch {
      url = "https://github.com/Gregwar/fatcat/commit/2e3476a84cbe32598d36b5506c21025b3f94eb03.patch";
      hash = "sha256-e5qGcpdHhbp2mZ7O3vBAJnSW5K2aXEfNVUfK/brx9a8=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "FAT filesystems explore, extract, repair, and forensic tool";
    mainProgram = "fatcat";
    homepage = "https://github.com/Gregwar/fatcat";
    license = licenses.mit;
    maintainers = with maintainers; [ cynerd ];
  };
}
