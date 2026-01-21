{
  lib,
  stdenv,
  fetchzip,
  libX11,
  libXinerama,
  libXft,
  writeText,
  pkg-config,
  # customization
  config,
  conf ? config.dwm.conf or null,
  patches ? config.dwm.patches or [ ],
  extraLibs ? config.dwm.extraLibs or [ ],
  # update script dependencies
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwm";
  version = "6.6";

  src = fetchzip {
    url = "https://dl.suckless.org/dwm/dwm-${finalAttrs.version}.tar.gz";
    hash = "sha256-fD97OpObSOBTAMc3teejS0u2h4hCkMVYJrNZ6F4IaFs=";
  };

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isStatic pkg-config;

  buildInputs = [
    libX11
    libXinerama
    libXft
  ]
  ++ extraLibs;

  preBuild = ''
    makeFlagsArray+=(
      "PREFIX=$out"
      "CC=$CC"
      ${lib.optionalString stdenv.hostPlatform.isStatic ''
        LDFLAGS="$(${stdenv.cc.targetPrefix}pkg-config --static --libs x11 xinerama xft)"
      ''}
    )
  '';

  # Allow users set their own list of patches
  inherit patches;

  # Allow users to set the config.def.h file containing the configuration
  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf then conf else writeText "config.def.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} config.def.h";

  passthru.updateScript = gitUpdater {
    url = "git://git.suckless.org/dwm";
  };

  meta = {
    homepage = "https://dwm.suckless.org/";
    description = "Extremely fast, small, and dynamic window manager for X";
    longDescription = ''
      dwm is a dynamic window manager for X. It manages windows in tiled,
      monocle and floating layouts. All of the layouts can be applied
      dynamically, optimising the environment for the application in use and the
      task performed.
      Windows are grouped by tags. Each window can be tagged with one or
      multiple tags. Selecting certain tags displays all windows with these
      tags.
    '';
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "dwm";
  };
})
