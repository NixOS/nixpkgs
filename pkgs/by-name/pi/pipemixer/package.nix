{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  inih,
  ncurses,
  pipewire,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipemixer";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "heather7283";
    repo = "pipemixer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dVw8x9c3DFSL5eLbBOe7ExNzeKsj3xB5Spl516XFqTQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    inih
    ncurses
    pipewire
  ];

  meta = {
    description = "A TUI volume control app for pipewire";
    homepage = "https://github.com/heather7283/pipemixer";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "pipemixer";
  };
})
