{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  python3,
  glib,
  libuuid,
  sqlite,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "pyzy";
  version = "1.1-unstable-2026-02-28";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "pyzy";
    rev = "5ac51d833777a881e80f0b23d704345cf0feb0d0";
    hash = "sha256-OiFdog34kjmgF2DCnA8LjlZseZPQ8iCYQD4HZKNnCVU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
  ];

  buildInputs = [
    glib
    libuuid
    sqlite
  ];

  postPatch = ''
    patchShebangs ./data/db/android/create_db.py
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Chinese PinYin and Bopomofo conversion library";
    homepage = "https://github.com/openSUSE/pyzy";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ azuwis ];
    platforms = lib.platforms.linux;
  };
}
