# Builder for JetBrains IDEs (`mkJetBrainsProduct`)

{
  lib,
  stdenv,
  callPackage,

  jdk,
  fontconfig,
  libGL,
  libX11,

  vmopts ? null,
  forceWayland ? false,
}:
let
  baseBuilder = if stdenv.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix;
  mkJetBrainsProductCore = callPackage baseBuilder { inherit vmopts; };
in
# Makes a JetBrains IDE
{
  pname,
  src,
  version,
  buildNumber,
  wmClass,
  product,
  productShort ? product,
  meta,

  libdbm,
  fsnotifier,

  extraWrapperArgs ? [ ],
  extraLdPath ? [ ],
  buildInputs ? [ ],
  passthru ? { },
}:
mkJetBrainsProductCore {
  inherit
    pname
    extraLdPath
    jdk
    src
    version
    buildNumber
    wmClass
    product
    productShort
    libdbm
    fsnotifier
    ;

  buildInputs =
    buildInputs
    ++ [ stdenv.cc.cc ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      fontconfig
      libGL
      libX11
    ];

  extraWrapperArgs =
    extraWrapperArgs
    ++ lib.optionals (stdenv.hostPlatform.isLinux && forceWayland) [
      ''--add-flags "\''${WAYLAND_DISPLAY:+-Dawt.toolkit.name=WLToolkit}"''
    ];

  passthru = lib.recursiveUpdate passthru {
    inherit
      buildNumber
      product
      libdbm
      fsnotifier
      ;

    updateScript = ../updater/main.py;

    tests = {
      plugins = callPackage ../plugins/tests.nix { ideName = pname; };
    };
  };

  meta = meta // {
    teams = [ lib.teams.jetbrains ];
  };
}
