{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxkbcommon,
  pango,
  which,
  git,
  cairo,
  libxcb,
  xcb-imdkit,
  xcb-util-cursor,
  xcbutilkeysyms,
  xcbutil,
  xcbutilwm,
  xcbutilxrm,
  libstartup_notification,
  bison,
  flex,
  librsvg,
  check,
  glib,
  buildPackages,
  pandoc,

  waylandSupport ? false,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:
let
  version = if !waylandSupport then "1.7.9.1" else "1.7.9+wayland1";
  repoBase = {
    owner = "davatorium";
    repo = "rofi";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-HZMVGlK6ig7kWf/exivoiTe9J/SLgjm7VwRm+KgKN44=";
  };
  repoWayland = repoBase // {
    owner = "lbonn";
    hash = "sha256-tLSU0Q221Pg3JYCT+w9ZT4ZbbB5+s8FwsZa/ehfn00s=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rofi${lib.optionalString waylandSupport "-wayland"}-unwrapped";
  inherit version;

  src = fetchFromGitHub (if !waylandSupport then repoBase else repoWayland);

  preConfigure = ''
    patchShebangs "script"
    # root not present in build /etc/passwd
    sed -i 's/~root/~nobody/g' test/helper-expand.c
  '';

  depsBuildBuild = [
    buildPackages.stdenv.cc
    pkg-config
    glib
  ];
  nativeBuildInputs =
    [
      meson
      ninja
      pkg-config
      flex
      bison
      pandoc
    ]
    ++ lib.optionals waylandSupport [
      wayland-protocols
      wayland-scanner
    ];
  buildInputs =
    [
      libxkbcommon
      pango
      cairo
      git
      librsvg
      check
      libstartup_notification
      libxcb
      xcb-imdkit
      xcb-util-cursor
      xcbutilkeysyms
      xcbutil
      xcbutilwm
      xcbutilxrm
      which
    ]
    ++ lib.optionals waylandSupport [
      wayland
      wayland-protocols
    ];

  mesonFlags = [ "-Dimdkit=true" ];

  doCheck = false;

  meta = {
    description =
      "Window switcher, run dialog and dmenu replacement"
      + lib.optionalString waylandSupport " for Wayland";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bew
    ];
    platforms = lib.platforms.linux;
    mainProgram = "rofi";
  };
})
