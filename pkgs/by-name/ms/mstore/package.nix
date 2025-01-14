{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  python3,
  mctc-lib,
}:

stdenv.mkDerivation rec {
  pname = "mstore";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zfrxdrZ1Um52qTRNGJoqZNQuHhK3xM/mKfk0aBLrcjw=";
  };

  nativeBuildInputs = [
    gfortran
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [ mctc-lib ];

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    patchShebangs --build config/install-mod.py
  '';

  meta = with lib; {
    description = "Molecular structure store for testing";
    license = licenses.asl20;
    homepage = "https://github.com/grimme-lab/mstore";
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
