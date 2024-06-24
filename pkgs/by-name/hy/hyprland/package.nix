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
, epoll-shim
, expat
, fribidi
, git
, hyprcursor
, hyprland-protocols
, hyprlang
, hyprutils
, hyprwayland-scanner
, jq
, libGL
, libdrm
, libdatrie
, libexecinfo
, libinput
, libselinux
, libsepol
, libthai
, libuuid
, libxkbcommon
, mesa
, pango
, pciutils
, pcre2
, pkgconf
, python3
, systemd
, tomlplusplus
, wayland
, wayland-protocols
, wayland-scanner
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
let
  info = builtins.fromJSON (builtins.readFile ./info.json);
in
assert lib.assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been removed.";
assert lib.assertMsg (!enableNvidiaPatches) "The option `enableNvidiaPatches` has been removed.";
assert lib.assertMsg (!hidpiXWayland) "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "0.41.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    fetchSubmodules = true;
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-hLnnNBWP1Qjs1I3fndMgp8rbWJruxdnGTq77A4Rv4R4=";
  };

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp

    # Remove extra @PREFIX@ to fix pkg-config paths
    sed -i "s#@PREFIX@/##g" hyprland.pc.in
  '';

  # variables used by generateVersion.sh script, and shown in `hyprctl version`
  BRANCH = info.branch;
  COMMITS = info.commit_hash;
  DATE = info.date;
  DIRTY = "";
  HASH = info.commit_hash;
  MESSAGE = info.commit_message;
  TAG = info.tag;

  depsBuildBuild = [
    # to find wayland-scanner when cross-compiling
    pkg-config
  ];

  nativeBuildInputs = [
    hwdata
    hyprwayland-scanner
    jq
    makeWrapper
    cmake
    meson # for wlroots
    ninja
    pkg-config
    wayland-scanner
    python3 # for udis86
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = [
    cairo
    expat
    fribidi
    git
    hyprcursor.dev
    hyprland-protocols
    hyprlang
    hyprutils
    libGL
    libdatrie
    libdrm
    libinput
    libselinux
    libsepol
    libthai
    libuuid
    libxkbcommon
    mesa
    wayland
    wayland-protocols
    pango
    pciutils
    pcre2
    tomlplusplus
    # for subproject wlroots-hyprland
    seatd
    libliftoff
    libdisplay-info
    xorg.xcbutilerrors
    xorg.xcbutilrenderutil
  ]
  ++ lib.optionals stdenv.hostPlatform.isBSD [ epoll-shim ]
  ++ lib.optionals stdenv.hostPlatform.isMusl [ libexecinfo ]
  ++ lib.optionals enableXWayland [
    xorg.libxcb
    xorg.libXdmcp
    xorg.xcbutil
    xorg.xcbutilwm
    xwayland
  ]
  ++ lib.optionals withSystemd [ systemd ];

  cmakeBuildType =
    if debug
    then "Debug"
    else "RelWithDebInfo";


  cmakeFlags = [
    (lib.cmakeBool "NO_XWAYLAND" (!enableXWayland))
    (lib.cmakeBool "LEGACY_RENDERER" legacyRenderer)
    (lib.cmakeBool "NO_SYSTEMD" (!withSystemd))
  ];

  postInstall = ''
    ${lib.optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${lib.makeBinPath [binutils pciutils pkgconf]}
    ''}
  '';

  passthru.providedSessions = [ "hyprland" ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/hyprwm/Hyprland";
    description = "A dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      wozeparrot
      fufexan
    ];
    mainProgram = "Hyprland";
    platforms = lib.platforms.linux;
  };
})
