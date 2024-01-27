{ lib
, stdenv
, fetchFromGitHub
, intltool
, pkg-config
, wrapGAppsHook
, gtk3
, miniupnpc
}:

stdenv.mkDerivation rec {
  pname = "yaup";
  version = "unstable-2019-10-16";

  src = fetchFromGitHub {
    owner = "Holarse-Linuxgaming";
    repo = "yaup";
    rev = "7ee3fdbd8c1ecf0a0e6469c47560e26082808250";
    hash = "sha256-RWnNjpgXRYncz9ID8zirENffy1UsfHD1H6Mmd8DKN4k=";
  };

  nativeBuildInputs = [
    intltool
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    miniupnpc
  ];

  meta = with lib; {
    homepage = "https://github.com/Holarse-Linuxgaming/yaup";
    description = "Yet Another UPnP Portmapper";
    longDescription = ''
      Portmapping made easy.
      Portforward your incoming traffic to a specified local ip.
      Mostly used for IPv4.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # ld: unknown option: --export-dynamic
    broken = stdenv.isDarwin;
    mainProgram = "yaup";
  };
}
