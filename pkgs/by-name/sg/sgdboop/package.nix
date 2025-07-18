{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  pkg-config,
  wrapGAppsHook3,
}:
stdenv.mkDerivation rec {
  pname = "sgdboop";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "SteamGridDB";
    repo = "SGDBoop";
    tag = "v${version}";
    hash = "sha256-FpVQQo2N/qV+cFhYZ1FVm+xlPHSVMH4L+irnQEMlUQs=";
  };

  patches = [
    # Hide the app from app launchers, as it is not meant to be run directly
    # Remove when https://github.com/SteamGridDB/SGDBoop/pull/112 is merged
    ./hide_desktop_entry.patch
  ];

  makeFlags = [
    # The flatpak install just copies things to /app - otherwise wants to do things with XDG
    "FLATPAK_ID=fake"
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/app/" "$out/"
  '';

  postInstall = ''
    rm -r "$out/share/metainfo"
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    curl
  ];

  meta = {
    description = "Applying custom artwork to Steam, using SteamGridDB";
    homepage = "https://github.com/SteamGridDB/SGDBoop/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      saturn745
      fazzi
    ];
    mainProgram = "SGDBoop";
    platforms = lib.platforms.linux;
  };
}
