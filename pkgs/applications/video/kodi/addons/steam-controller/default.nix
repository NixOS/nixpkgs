{ lib, buildKodiBinaryAddon, fetchFromGitHub, libusb1 }:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "peripheral.steamcontroller";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = namespace;
    rev = "f68140ca44f163a03d3a625d1f2005a6edef96cb";
    sha256 = "09lm8i119xlsxxk0c64rnp8iw0crr90v7m8iwi9r31qdmxrdxpmg";
  };

  extraBuildInputs = [ libusb1 ];

  meta = with lib; {
    description = "Binary addon for steam controller.";
    platforms = platforms.all;
    maintainers = teams.kodi.members;
  };
}
