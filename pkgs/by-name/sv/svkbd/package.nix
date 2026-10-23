{
  lib,
  stdenv,
  fetchurl,
  writeText,
  pkg-config,
  libx11,
  libxft,
  libxi,
  libxinerama,
  libxtst,
  layout ? "mobile-intl",
  conf ? null,
  patches ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "svkbd";
  version = "0.4.2";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/svkbd-${finalAttrs.version}.tar.gz";
    hash = "sha256-bZQyGeMzMUdYY0ZmdKB2CFhZygDc6UDlTU4kdx+UZoA=";
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

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libx11
    libxft
    libxi
    libxinerama
    libxtst
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LAYOUT=${layout}"
  ];

  meta = {
    description = "Simple virtual keyboard";
    homepage = "https://tools.suckless.org/x/svkbd/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "svkbd-${layout}";
  };
})
