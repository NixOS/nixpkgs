{
  lib,
  stdenv,
  fetchFromSourcehut,
  writeText,
  libinput,
  libX11,
  wayland,
  conf ? null,
  patches ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lisgd";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~mil";
    repo = "lisgd";
    rev = finalAttrs.version;
    hash = "sha256-ljRZpBo4lW2cYZYxKKMrXanE0YaHSFwcdyECK0czdWY=";
  };

  inherit patches;

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || lib.isPath conf then conf else writeText "config.def.h" conf;
    in
    lib.optionalString (conf != null) ''
      cp ${configFile} config.def.h
    '';

  buildInputs = [
    libinput
    libX11
    wayland
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  meta = {
    description = "Bind gestures via libinput touch events";
    mainProgram = "lisgd";
    homepage = "https://git.sr.ht/~mil/lisgd";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
