{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pkg-config,
  glib,
  libsigrok,
  libsigrokdecode,
}:

stdenv.mkDerivation {
  pname = "sigrok-cli";
  version = "0.8.0-unstable-2024-08-26";

  src = fetchgit {
    url = "git://sigrok.org/sigrok-cli";
    rev = "f44dd91347e7ac797cefc23162b9fcf0b7329f1f";
    hash = "sha256-LJ+32XiQYfjMLYze/zICVKvqmhtyc85zvxAXXi2HIi0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    glib
    libsigrok
    libsigrokdecode
  ];

  meta = {
    description = "Command-line frontend for the sigrok signal analysis software suite";
    mainProgram = "sigrok-cli";
    homepage = "https://sigrok.org/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      bjornfor
      vifino
    ];
  };
}
