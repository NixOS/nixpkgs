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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rmw";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "theimpossibleastronaut";
    repo = "rmw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bE9fFjn3mPfUbtsB6bXfQAxUtbtuZiT4pevi5RCQA4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    canfigger
    ncurses
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin gettext;

  meta = {
    description = "Trashcan/ recycle bin utility for the command line";
    homepage = "https://github.com/theimpossibleastronaut/rmw";
    changelog = "https://github.com/theimpossibleastronaut/rmw/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "rmw";
  };
})
