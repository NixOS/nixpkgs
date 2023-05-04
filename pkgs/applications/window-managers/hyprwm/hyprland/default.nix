{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, meson
, ninja
, cairo
, git
, hyprland-protocols
, jq
, libdrm
, libinput
, libxcb
, libxkbcommon
, mesa
, pango
, pciutils
, systemd
, udis86
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, xcbutilwm
, xwayland
, debug ? false
, enableXWayland ? true
, hidpiXWayland ? false
, legacyRenderer ? false
, nvidiaPatches ? false
, withSystemd ? true
}:
let
  assertXWayland = lib.assertMsg (hidpiXWayland -> enableXWayland) ''
    Hyprland: cannot have hidpiXWayland when enableXWayland is false.
  '';
in
assert assertXWayland;
stdenv.mkDerivation rec {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland";
    rev = "v${version}";
    hash = "sha256-zbtxX0NezuNg46PAKscmDfFfNID4rAq2qGNf1BE3Cqc=";
  };

  patches = [
    # make meson use the provided dependencies instead of the git submodules
    "${src}/nix/meson-build.patch"
  ];

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp
    substituteInPlace meson.build \
      --replace "@GIT_COMMIT_HASH@" '${version}' \
      --replace "@GIT_DIRTY@" ""
  '';

  nativeBuildInputs = [
    jq
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  outputs = [
    "out"
    "man"
  ];

  buildInputs =
    [
      cairo
      git
      hyprland-protocols
      libdrm
      libinput
      libxkbcommon
      mesa
      udis86
      wayland
      wayland-protocols
      pango
      pciutils
      (wlroots.override { inherit enableXWayland hidpiXWayland nvidiaPatches; })
    ]
    ++ lib.optionals enableXWayland [ libxcb xcbutilwm xwayland ]
    ++ lib.optionals withSystemd [ systemd ];

  mesonBuildType =
    if debug
    then "debug"
    else "release";

  mesonFlags = builtins.concatLists [
    (lib.optional (!enableXWayland) "-Dxwayland=disabled")
    (lib.optional legacyRenderer "-DLEGACY_RENDERER:STRING=true")
    (lib.optional withSystemd "-Dsystemd=enabled")
  ];


  passthru.providedSessions = [ "hyprland" ];

  meta = with lib; {
    homepage = "https://github.com/vaxerski/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    mainProgram = "Hyprland";
    platforms = wlroots.meta.platforms;
  };
}
