{
  lib,
  buildKodiBinaryAddon,
  fetchFromGitHub,
  libusb1,
}:
buildKodiBinaryAddon rec {
  pname = namespace;
  namespace = "peripheral.steamcontroller";
  version = "20.0.2";

  src = fetchFromGitHub {
    owner = "kodi-game";
    repo = namespace;
    rev = "b3174673c6feb34325975b6c007581c39bf3e4a5";
    sha256 = "sha256-Q+eJfbD4NpAPANm9Mx9/pD29L5tdS4gxhQqNufufYdw=";
  };

  extraBuildInputs = [ libusb1 ];

  meta = with lib; {
    description = "Binary addon for steam controller";
    platforms = platforms.all;
    teams = [ teams.kodi ];
  };
}
