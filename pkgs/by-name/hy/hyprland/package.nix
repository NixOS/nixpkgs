{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  cmake,
  ninja,
  aquamarine,
  binutils,
  cairo,
  epoll-shim,
  expat,
  fribidi,
  git,
  hwdata,
  hyprcursor,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  jq,
  libGL,
  libdatrie,
  libdisplay-info,
  libdrm,
  libexecinfo,
  libinput,
  libliftoff,
  libselinux,
  libsepol,
  libthai,
  libuuid,
  libxkbcommon,
  mesa,
  pango,
  pciutils,
  pcre2,
  pkgconf,
  python3,
  seatd,
  systemd,
  tomlplusplus,
  wayland,
  wayland-protocols,
  wayland-scanner,
  xorg,
  xwayland,
  debug ? false,
  enableXWayland ? true,
  legacyRenderer ? false,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  wrapRuntimeDeps ? true,
  # deprecated flags
  nvidiaPatches ? false,
  hidpiXWayland ? false,
  enableNvidiaPatches ? false,
}:
let
  info = builtins.fromJSON (builtins.readFile ./info.json);
in
assert lib.assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been removed.";
assert lib.assertMsg (!enableNvidiaPatches) "The option `enableNvidiaPatches` has been removed.";
assert lib.assertMsg (!hidpiXWayland)
  "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + lib.optionalString debug "-debug";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland";
    fetchSubmodules = true;
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-deu8zvgseDg2gQEnZiCda4TrbA6pleE9iItoZlsoMtE=";
  };

  # Fixes broken OpenGL applications on Apple silicon (Asahi Linux)
  # Based on commit https://github.com/hyprwm/Hyprland/commit/279ec1c291021479b050c83a0435ac7076c1aee0
  patches = [ ./asahi-fix.patch ];

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
    hyprwayland-scanner
    jq
    makeWrapper
    cmake
    ninja
    pkg-config
    python3 # for udis86
    wayland-scanner
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs =
    [
      aquamarine
      cairo
      expat
      fribidi
      git
      hwdata
      hyprcursor.dev
      hyprlang
      hyprutils
      libGL
      libdatrie
      libdisplay-info
      libdrm
      libinput
      libliftoff
      libselinux
      libsepol
      libthai
      libuuid
      libxkbcommon
      mesa
      pango
      pciutils
      pcre2
      seatd
      tomlplusplus
      wayland
      wayland-protocols
      xorg.libXcursor
    ]
    ++ lib.optionals stdenv.hostPlatform.isBSD [ epoll-shim ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [ libexecinfo ]
    ++ lib.optionals enableXWayland [
      xorg.libxcb
      xorg.libXdmcp
      xorg.xcbutil
      xorg.xcbutilerrors
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xwayland
    ]
    ++ lib.optionals withSystemd [ systemd ];

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  dontStrip = debug;

  cmakeFlags = [
    (lib.cmakeBool "NO_XWAYLAND" (!enableXWayland))
    (lib.cmakeBool "LEGACY_RENDERER" legacyRenderer)
    (lib.cmakeBool "NO_SYSTEMD" (!withSystemd))
  ];

  postInstall = ''
    ${lib.optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${
          lib.makeBinPath [
            binutils
            pciutils
            pkgconf
          ]
        }
    ''}
  '';

  passthru.providedSessions = [ "hyprland" ];

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://github.com/hyprwm/Hyprland";
    description = "Dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fufexan
      johnrtitor
      wozeparrot
    ];
    mainProgram = "Hyprland";
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
