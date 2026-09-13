{
  fetchFromSourcehut,
  lib,
  libxkbcommon,
  neuswc,
  nix-update-script,
  pkg-config,
  stdenv,
  wayland,
  writeText,
  conf ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hevel";
  version = "0-unstable-2026-05-07";

  src = fetchFromSourcehut {
    owner = "~dlm";
    repo = "hevel";
    rev = "7ef61a5c0d4012417443734919ac723635cd5464";
    hash = "sha256-ad4euUV+jJYG58aO9tfKyCq8sznDf2tHj7RmORqnP1o=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbcommon
    neuswc
    wayland
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.h" conf;
    in
    lib.optionalString (conf != null) "cp {configFile} config.h";

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
    platforms = lib.platforms.unix;
  };
})
