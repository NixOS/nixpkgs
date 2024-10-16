{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
  dtc,
}:

stdenv.mkDerivation rec {
  pname = "culvert";
  version = "0.4.0.unstable-2024-10-16";

  src = fetchFromGitHub {
    owner = "amboar";
    repo = "culvert";
    rev = "e0f9ac24c89c0ac0e56d4471dfb608380b38355b";
    hash = "sha256-d+mBf5J5lo3v3yA2FFU6f/8dor4gPOPZEq4YQp6tZ3s=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/amboar/culvert/pull/64.patch";
      hash = "sha256-uM1a4vpz+U9AjMhvcDXhOtMCWQsKOPJ+vCzYdfBGDzo=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    dtc # The dtc binary to compile device trees
  ];

  buildInputs = [
    dtc # provides libfdt
  ];

  mesonFlags = [
    "-Db_lto=false"
  ];

  meta = with lib; {
    homepage = "https://github.com/amboar/culvert";
    description = "A Test and Debug Tool for BMC AHB Interfaces ";
    mainProgram = "culvert";
    license = licenses.asl20;
    maintainers = [ maintainers.baloo ];
    platforms = platforms.linux;
  };
}
