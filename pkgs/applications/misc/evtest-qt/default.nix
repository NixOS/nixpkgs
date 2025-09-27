{
  mkDerivation,
  lib,
  qtbase,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
}:

mkDerivation {
  pname = "evtest-qt";
  version = "0.2.0-unstable-2023-09-13";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "evtest-qt";
    rev = "fb087f4d3d51377790f1ff30681c48031bf23145";
    hash = "sha256-gE47x1J13YZUVyB0b4VRyESIVCm3GbOXp2bX0TP97UU=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix build against gcc-13:
    #   https://github.com/Grumbel/evtest-qt/pull/14
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/Grumbel/evtest-qt/commit/975dedcfd60853bd329f34d48ce4740add8866eb.patch";
      hash = "sha256-gR/9oVhO4G9i7dn+CjvDAQN0KLXoX/fatpE0W3gXDc0=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ qtbase ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Simple input device tester for linux with Qt GUI";
    mainProgram = "evtest-qt";
    homepage = "https://github.com/Grumbel/evtest-qt";
    maintainers = with maintainers; [ alexarice ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
