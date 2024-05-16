{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, meson
, cmake
, ninja
, binutils
, cairo
, git
, hyprcursor
, hyprland-protocols
, hyprlang
, jq
, libGL
, libdrm
, libexecinfo
, libinput
, libxcb
, libxkbcommon
, mesa
, pango
, pciutils
, python3
, systemd
, tomlplusplus
, wayland
, wayland-protocols
, wayland-scanner
, xcbutilwm
, xwayland
, hwdata
, seatd
, libdisplay-info
, libliftoff
, xorg
, debug ? false
, enableXWayland ? true
, legacyRenderer ? false
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, wrapRuntimeDeps ? true
  # deprecated flags
, nvidiaPatches ? false
, hidpiXWayland ? false
, enableNvidiaPatches ? false
}:
assert lib.assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been removed.";
assert lib.assertMsg (!enableNvidiaPatches) "The option `enableNvidiaPatches` has been removed.";
assert lib.assertMsg (!hidpiXWayland) "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "0.39.1";
  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    fetchSubmodules = true;
    rev = "v${finalAttrs.version}";
    hash = "sha256-7L5rqQRYH2iyyP5g3IdXJSlATfgnKhuYMf65E48MVKw=";
  };

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp

    # Generate version.h
    cp src/version.h.in src/version.h
    substituteInPlace src/version.h \
      --replace-fail "@HASH@" '${finalAttrs.src.rev}' \
      --replace-fail "@BRANCH@" "" \
      --replace-fail "@MESSAGE@" "" \
      --replace-fail "@DATE@" "2024-04-16" \
      --replace-fail "@TAG@" "" \
      --replace-fail "@DIRTY@" ""
  '';

  depsBuildBuild = [
    # to find wayland-scanner when cross-compiling
    pkg-config
  ];

  nativeBuildInputs = [
    hwdata
    jq
    makeWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
    cmake # for subproject udis86
    python3
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = [
    cairo
    git
    hyprcursor
    hyprland-protocols
    hyprlang
    libGL
    libdrm
    libinput
    libxkbcommon
    mesa
    wayland
    wayland-protocols
    pango
    pciutils
    tomlplusplus
    # for subproject wlroots-hyprland
    seatd
    libliftoff
    libdisplay-info
    xorg.xcbutilerrors
    xorg.xcbutilrenderutil
  ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [ libexecinfo ]
  ++ lib.optionals enableXWayland [ libxcb xcbutilwm xwayland ]
  ++ lib.optionals withSystemd [ systemd ];

  mesonBuildType =
    if debug
    then "debug"
    else "release";

  mesonAutoFeatures = "enabled";

  mesonFlags = [
    (lib.mesonEnable "xwayland" enableXWayland)
    (lib.mesonEnable "legacy_renderer" legacyRenderer)
    (lib.mesonEnable "systemd" withSystemd)
  ];

  postInstall = ''
    ${lib.optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${lib.makeBinPath [binutils pciutils stdenv.cc]}
    ''}
  '';

  passthru.providedSessions = [ "hyprland" ];

  meta = with lib; {
    homepage = "https://github.com/hyprwm/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wozeparrot fufexan ];
    mainProgram = "Hyprland";
    platforms = lib.platforms.linux;
  };
})
