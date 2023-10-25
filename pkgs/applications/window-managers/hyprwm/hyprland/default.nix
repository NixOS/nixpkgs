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
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-mEKF6Wcx+wSF/eos/91A7LxhFLDYhSnQnLpwZF13ntg=";
  };

  patches = [
    # make meson use the provided dependencies instead of the git submodules
    "${finalAttrs.src}/nix/meson-build.patch"
    # look into $XDG_DESKTOP_PORTAL_DIR instead of /usr; runtime checks for conflicting portals
    "${finalAttrs.src}/nix/portals.patch"
  ];

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp
    substituteInPlace meson.build \
      --replace "@GIT_COMMIT_HASH@" '${finalAttrs.src.rev}' \
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
    "dev"
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
})
