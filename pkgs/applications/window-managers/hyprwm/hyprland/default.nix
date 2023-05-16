{ lib
, stdenv
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, makeWrapper
, meson
, ninja
, binutils
=======
, meson
, ninja
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, cairo
, git
, hyprland-protocols
, jq
, libdrm
<<<<<<< HEAD
, libexecinfo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, enableNvidiaPatches ? false
, enableXWayland ? true
, legacyRenderer ? false
, withSystemd ? true
, wrapRuntimeDeps ? true
  # deprecated flags
, nvidiaPatches ? false
, hidpiXWayland ? false
}:
assert lib.assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been renamed `enableNvidiaPatches`";
assert lib.assertMsg (!hidpiXWayland) "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "unstable-2023-08-15";
=======
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
  version = "0.25.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
<<<<<<< HEAD
    rev = "91e28bbe9df85e2e94fbcc0137106362aea14ab5";
    hash = "sha256-1vLms49ZgDOC9y1uTjfph3WrUpatKRLnKAvFmSNre20=";
=======
    rev = "v${finalAttrs.version}";
    hash = "sha256-Npf48UUfywneFYGEc7NQ59xudwvw7EJjwweT4tHguIY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # make meson use the provided dependencies instead of the git submodules
<<<<<<< HEAD
    "${finalAttrs.src}/nix/patches/meson-build.patch"
    # look into $XDG_DESKTOP_PORTAL_DIR instead of /usr; runtime checks for conflicting portals
    # NOTE: revert back to the patch inside SRC on the next version bump
    # "${finalAttrs.src}/nix/patches/portals.patch"
    ./portals.patch
=======
    "${finalAttrs.src}/nix/meson-build.patch"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    makeWrapper
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      (wlroots.override { inherit enableNvidiaPatches; })
    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [ libexecinfo ]
=======
      (wlroots.override { inherit enableXWayland hidpiXWayland nvidiaPatches; })
    ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postInstall = ''
    ln -s ${wlroots}/include/wlr $dev/include/hyprland/wlroots
    ${lib.optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${lib.makeBinPath [binutils pciutils]}
    ''}
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
