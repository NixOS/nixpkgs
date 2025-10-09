{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  dtc,
}:

stdenv.mkDerivation {
  pname = "culvert";
  version = "0.4.0.unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "amboar";
    repo = "culvert";
    rev = "770a6ed4badec1c6e3079cd9b354d0996d55b326";
    hash = "sha256-Lj72uYItTxTVYcSEbr/XezeyFvrcqqMTu74tOE+DwJE=";
  };

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
    description = "Test and Debug Tool for BMC AHB Interfaces ";
    mainProgram = "culvert";
    license = licenses.asl20;
    maintainers = [ maintainers.baloo ];
    platforms = platforms.linux;
  };
}
