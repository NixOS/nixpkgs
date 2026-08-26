{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  canfigger,
  ncurses,
  gettext,
  glib,
  linuxHeaders,
}:

let
  version = "0.10.0";
in
stdenv.mkDerivation (finalAttrs: {
  inherit version;
  pname = "rmw";

  src = fetchFromGitHub {
    owner = "theimpossibleastronaut";
    repo = "rmw";
    tag = "v${version}";
    hash = "sha256-NT6P0/pPYyAlno+w0DZoZUepm8cbwlc3+Ety15CKV+g=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux linuxHeaders;

  buildInputs = [
    canfigger
    ncurses
    glib
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gettext;

  meta = {
    description = "trashcan/recycle bin utility for the command line";
    homepage = "https://github.com/theimpossibleastronaut/rmw";
    changelog = "https://github.com/theimpossibleastronaut/rmw/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      _0k4r1m
    ];
    mainProgram = "rmw";
  };
})
