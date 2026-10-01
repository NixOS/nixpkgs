# TODO: replace build system with meson next update
{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  util-macros,
  autoreconfHook,
  libx11,
  libxkbfile,
  libxrandr,
  xkeyboard-config,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "setxkbmap";
  version = "1.3.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "setxkbmap";
    tag = "setxkbmap-${finalAttrs.version}";
    hash = "sha256-eEh1rifV+XY5RuKbA3Rgn9vmQPnyWvSae/m5lZA3FGE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    util-macros
    autoreconfHook
  ];

  buildInputs = [
    libx11
    libxkbfile
    libxrandr
  ];

  configureFlags = [ "--with-xkb-config-root=${xkeyboard-config}/etc/X11/xkb" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=setxkbmap-(.*)" ]; };

  meta = {
    description = "Set keymaps, layouts, and options via the X Keyboard Extension (XKB)";
    longDescription = ''
      setxkbmap is an X11 client to change the keymaps in the X server for a specified keyboard to
      use the layout determined by the options listed on the command line.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/app/setxkbmap";
    license = lib.licenses.hpnd;
    mainProgram = "setxkbmap";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
