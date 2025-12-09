{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  bison,
  doxygen,
  xkeyboard_config,
  libxcb,
  libxml2,
  python3,
  libX11,
  # To enable the "interactive-wayland" subcommand of xkbcli. This is the
  # wayland equivalent of `xev` on X11.
  xorg,
  withWaylandTools ? stdenv.hostPlatform.isLinux,
  wayland,
  wayland-protocols,
  wayland-scanner,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxkbcommon";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "xkbcommon";
    repo = "libxkbcommon";
    tag = "xkbcommon-${finalAttrs.version}";
    hash = "sha256-IV1dgGM8z44OQCQYQ5PiUUw/zAvG5IIxiBywYVw2ius=";
  };

  patches = [
    # Disable one Xvfb test as it fails for permission checks.
    ./disable-x11com.patch
  ];

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    bison
    doxygen
  ]
  ++ lib.optional stdenv.isLinux xorg.xvfb
  ++ lib.optional withWaylandTools wayland-scanner;

  buildInputs = [
    xkeyboard_config
    libxcb
    libxml2
  ]
  ++ lib.optionals withWaylandTools [
    wayland
    wayland-protocols
  ];
  nativeCheckInputs = [ python3 ];

  mesonFlags = [
    "-Dxkb-config-root=${xkeyboard_config}/etc/X11/xkb"
    "-Dxkb-config-extra-path=/etc/xkb" # default=$sysconfdir/xkb ($out/etc)
    "-Dx-locale-root=${libX11.out}/share/X11/locale"
    "-Denable-docs=true"
    "-Denable-wayland=${lib.boolToString withWaylandTools}"
  ];

  doCheck = stdenv.isLinux; # TODO: disable just a part of the tests
  preCheck = ''
    patchShebangs ../test/
  '';

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Library to handle keyboard descriptions";
    longDescription = ''
      libxkbcommon is a keyboard keymap compiler and support library which
      processes a reduced subset of keymaps as defined by the XKB (X Keyboard
      Extension) specification. It also contains a module for handling Compose
      and dead keys.
    ''; # and a separate library for listing available keyboard layouts.
    homepage = "https://xkbcommon.org";
    changelog = "https://github.com/xkbcommon/libxkbcommon/blob/xkbcommon-${finalAttrs.version}/NEWS.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      ttuegel
    ];
    mainProgram = "xkbcli";
    platforms = with platforms; unix;
    pkgConfigModules = [
      "xkbcommon"
      "xkbcommon-x11"
      "xkbregistry"
    ];
  };
})
