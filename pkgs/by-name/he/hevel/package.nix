{
  fetchFromSourcehut,
  fontconfig,
  lib,
  libdrm,
  libinput,
  libxcb-wm,
  libxkbcommon,
  neuswc,
  neuwld,
  nix-update-script,
  pixman,
  pkg-config,
  stdenv,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hevel";
  version = "0-unstable-2026-03-15";

  src = fetchFromSourcehut {
    owner = "~dlm";
    repo = "hevel";
    rev = "cce195a2176163f099ed95c9bf7020033bdbbac9";
    hash = "sha256-9B180ebZzOtv9eEICVpYSo558T0/UYEVELFztPzOX4o=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fontconfig
    libdrm
    libinput
    libxcb-wm
    libxkbcommon
    neuswc
    neuwld
    pixman
    wayland
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Scrollable, floating window manager for Wayland";
    longDescription = ''
      "Make the user interface invisible"

      hevel is a scrollable, floating window manager for Wayland that
      uses mouse chords for all commands.

      Its design is inspired by ideas from Rob Pike's 1988 paper,
      "Window Systems Should be Transparent", taken to their logical
      extremes.  In this sense, hevel is a modernization of
      mouse-driven Unix and Plan 9 window systems such as mux, 8½, and
      rio.

      Unlike those systems, hevel has no menus and is not limited to a
      single screen of space.  Instead, the desktop is an infinite
      plane: windows can be created anywhere, and the view can be
      freely scrolled thru (vertically, or in all axis).
    '';
    homepage = "https://git.sr.ht/~dlm/hevel";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      ricardomaps
      yiyu
    ];
    platforms = lib.platforms.all;
  };
})
