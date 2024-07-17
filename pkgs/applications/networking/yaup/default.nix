{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  intltool,
  pkg-config,
  wrapGAppsHook3,
  gtk3,
  miniupnpc,
}:

stdenv.mkDerivation {
  pname = "yaup";
  version = "unstable-2019-10-16";

  src = fetchFromGitHub {
    owner = "Holarse-Linuxgaming";
    repo = "yaup";
    rev = "7ee3fdbd8c1ecf0a0e6469c47560e26082808250";
    hash = "sha256-RWnNjpgXRYncz9ID8zirENffy1UsfHD1H6Mmd8DKN4k=";
  };

  patches = [
    # Fix build with miniupnpc 2.2.8
    # https://github.com/Holarse-Linuxgaming/yaup/pull/6
    (fetchpatch2 {
      url = "https://github.com/Holarse-Linuxgaming/yaup/commit/c92134e305932785a60bd72131388f507b4d1853.patch?full_index=1";
      hash = "sha256-Exqkfp9VYIf9JpAc10cO8NuEAWvI5Houi7CLXV5zBDY=";
    })
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
    wrapGAppsHook3
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
