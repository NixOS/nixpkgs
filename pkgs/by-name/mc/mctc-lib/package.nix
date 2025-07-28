{
  stdenv,
  lib,
  fetchFromGitHub,
  gfortran,
  meson,
  ninja,
  pkg-config,
  python3,
  toml-f,
  jonquil,
}:

stdenv.mkDerivation rec {
  pname = "mctc-lib";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "grimme-lab";
    repo = "mctc-lib";
    rev = "v${version}";
    hash = "sha256-Qd7mpNE23Z+LuiUwhUzfVzVZEQ+sdnkxMm+W7Hlrss4=";
  };

  patches = [
    # Allow dynamically linked jonquil as dependency. That then additionally
    # requires linking in toml-f
    ./meson.patch
  ];

  nativeBuildInputs = [
    gfortran
    pkg-config
    python3
    meson
    ninja
  ];

  buildInputs = [
    toml-f
    jonquil
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs --build config/install-mod.py
  '';

  meta = with lib; {
    description = "Modular computation tool chain library";
    mainProgram = "mctc-convert";
    homepage = "https://github.com/grimme-lab/mctc-lib";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
