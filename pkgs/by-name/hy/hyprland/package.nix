{
  lib,
  gcc15Stdenv,
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
  glaze,
  hyprcursor,
  hyprgraphics,
  hyprland-qtutils,
  hyprlang,
  hyprutils,
  hyprwire,
  hyprwayland-scanner,
  libGL,
  libdrm,
  libexecinfo,
  libinput,
  libuuid,
  libxkbcommon,
  libgbm,
  muparser,
  pango,
  pciutils,
  pkgconf,
  python3,
  re2,
  systemd,
  tomlplusplus,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxcb-wm,
  libxcb-errors,
  libxdmcp,
  libxcursor,
  libxcb,
  xwayland,
  debug ? false,
  enableXWayland ? true,
  withSystemd ? lib.meta.availableOn gcc15Stdenv.hostPlatform systemd,
  wrapRuntimeDeps ? true,
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
    cmakeBool
    ;
  inherit (lib.trivial)
    importJSON
    ;

  info = importJSON ./info.json;

  # possibility to add more adapters in the future, such as keepDebugInfo,
  # which would be controlled by the `debug` flag
  # Condition on darwin to avoid breaking eval for darwin in CI,
  # even though darwin is not supported anyway.
  adapters = lib.optionals (!gcc15Stdenv.targetPlatform.isDarwin) [
    stdenvAdapters.useMoldLinker
  ];

  customStdenv = foldl' (acc: adapter: adapter acc) gcc15Stdenv adapters;
in
customStdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + optionalString debug "-debug";
  version = "0.54.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
    hash = "sha256-wfiduannx1mWvsGAfuMk8ipOU3AAFuJYPNV4D++dhPY=";
  };

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    substituteInPlace src/render/OpenGL.cpp \
      --replace-fail /usr $out

    # Remove extra @PREFIX@ to fix pkg-config paths
    substituteInPlace hyprland.pc.in \
      --replace-fail  "@PREFIX@/" ""
    substituteInPlace example/hyprland.desktop.in \
      --replace-fail  "@PREFIX@/" ""
  '';

  # variables used by CMake, and shown in `hyprctl version`
  env = {
    GIT_BRANCH = info.branch;
    # The amount of commits altogether. Not really worth getting that info from
    # GitHub's API, so we set a dummy value.
    GIT_COMMITS = "-1";
    GIT_COMMIT_DATE = info.date;
    GIT_DIRTY = "clean";
    GIT_COMMIT_HASH = info.commit_hash;
    GIT_COMMIT_MESSAGE = info.commit_message;
    GIT_TAG = info.tag;
  };

  depsBuildBuild = [
    # to find wayland-scanner when cross-compiling
    pkg-config
  ];

  nativeBuildInputs = [
    hyprwayland-scanner
    hyprwire
    makeWrapper
    cmake
    pkg-config
    wayland-scanner
    # for udis86
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
      glaze
      hyprcursor.dev
      hyprgraphics
      hyprlang
      hyprutils
      libGL
      libdrm
      libgbm
      libinput
      libuuid
      libxcursor
      libxkbcommon
      muparser
      pango
      pciutils
      re2
      tomlplusplus
      wayland
      wayland-protocols
    ]
    (optionals customStdenv.hostPlatform.isBSD [ epoll-shim ])
    (optionals customStdenv.hostPlatform.isMusl [ libexecinfo ])
    (optionals enableXWayland [
      libxcb
      libxcb-errors
      libxcb-wm
      libxdmcp
      xwayland
    ])
    (optionals withSystemd [ systemd ])
  ];

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  dontStrip = debug;
  strictDeps = true;

  cmakeFlags = mapAttrsToList cmakeBool {
    "BUILT_WITH_NIX" = true;
    "NO_XWAYLAND" = !enableXWayland;
    "NO_SYSTEMD" = !withSystemd;
    "CMAKE_DISABLE_PRECOMPILE_HEADERS" = true;
    "NO_UWSM" = !withSystemd;
    "TRACY_ENABLE" = false;
  };

  postInstall = ''
    ${optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${
          makeBinPath [
            binutils
            hyprland-qtutils
            pciutils
            pkgconf
          ]
        }
    ''}
  '';

  passthru = {
    providedSessions = [ "hyprland" ] ++ optionals withSystemd [ "hyprland-uwsm" ];
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://github.com/hyprwm/Hyprland";
    description = "Dynamic tiling Wayland compositor that doesn't sacrifice on its looks";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    mainProgram = "Hyprland";
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
