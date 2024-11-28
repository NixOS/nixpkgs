{
  lib,
  stdenv,
  stdenvAdapters,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  cmake,
  meson,
  ninja,
  aquamarine,
  binutils,
  cairo,
  epoll-shim,
  git,
  hyprcursor,
  hyprlang,
  hyprutils,
  hyprwayland-scanner,
  libGL,
  libdrm,
  libexecinfo,
  libinput,
  libuuid,
  libxkbcommon,
  mesa,
  pango,
  pciutils,
  pkgconf,
  python3,
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
  inherit (builtins)
    foldl'
    ;
  inherit (lib.asserts) assertMsg;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists)
    concatLists
    optionals
    ;
  inherit (lib.strings)
    makeBinPath
    optionalString
    mesonBool
    mesonEnable
    ;
  inherit (lib.trivial)
    importJSON
    ;

  info = importJSON ./info.json;

  # possibility to add more adapters in the future, such as keepDebugInfo,
  # which would be controlled by the `debug` flag
  adapters = [
    stdenvAdapters.useMoldLinker
  ];

  customStdenv = foldl' (acc: adapter: adapter acc) stdenv adapters;
in
assert assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been removed.";
assert assertMsg (!enableNvidiaPatches) "The option `enableNvidiaPatches` has been removed.";
assert assertMsg (!hidpiXWayland)
  "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";

customStdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + optionalString debug "-debug";
  version = "0.45.2";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland";
    fetchSubmodules = true;
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-1pNsLGNStCFjXiBc2zMUxKzKk45CePTf+GwKlzTmrCY=";
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
    hyprwayland-scanner
    makeWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
    # for udis86
    cmake
    python3
  ];

  outputs = [
    "out"
    "man"
    "dev"
  ];

  buildInputs = concatLists [
    [
      aquamarine
      cairo
      git
      hyprcursor.dev
      hyprlang
      hyprutils
      libGL
      libdrm
      libinput
      libuuid
      libxkbcommon
      mesa
      pango
      pciutils
      tomlplusplus
      wayland
      wayland-protocols
      xorg.libXcursor
    ]
    (optionals customStdenv.hostPlatform.isBSD [ epoll-shim ])
    (optionals customStdenv.hostPlatform.isMusl [ libexecinfo ])
    (optionals enableXWayland [
      xorg.libxcb
      xorg.libXdmcp
      xorg.xcbutilerrors
      xorg.xcbutilwm
      xwayland
    ])
    (optionals withSystemd [ systemd ])
  ];

  mesonBuildType = if debug then "debugoptimized" else "release";

  dontStrip = debug;

  mesonFlags = concatLists [
    (mapAttrsToList mesonEnable {
      "xwayland" = enableXWayland;
      "legacy_renderer" = legacyRenderer;
      "systemd" = withSystemd;
    })
    (mapAttrsToList mesonBool {
      # PCH provides no benefits when building with Nix
      "b_pch" = false;
      "tracy_enable" = false;
    })
  ];

  postInstall = ''
    ${optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${
          makeBinPath [
            binutils
            pciutils
            pkgconf
          ]
        }
    ''}
  '';

  passthru = {
    providedSessions = [ "hyprland" ];
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/hyprwm/Hyprland";
    description = "Dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      fufexan
      johnrtitor
      khaneliman
      wozeparrot
    ];
    mainProgram = "Hyprland";
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
