{
  lib,
<<<<<<< HEAD
  gcc15Stdenv,
=======
  stdenv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  glaze,
  hyprcursor,
  hyprgraphics,
  hyprland-qtutils,
  hyprlang,
  hyprutils,
<<<<<<< HEAD
  hyprwire,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  hyprwayland-scanner,
  libGL,
  libdrm,
  libexecinfo,
  libinput,
  libuuid,
  libxkbcommon,
  libgbm,
<<<<<<< HEAD
  muparser,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
  xorg,
  xwayland,
  debug ? false,
  enableXWayland ? true,
<<<<<<< HEAD
  withSystemd ? lib.meta.availableOn gcc15Stdenv.hostPlatform systemd,
=======
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  wrapRuntimeDeps ? true,
  # deprecated flags
  nvidiaPatches ? false,
  hidpiXWayland ? false,
  enableNvidiaPatches ? false,
  legacyRenderer ? false,
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
<<<<<<< HEAD
    cmakeBool
=======
    mesonBool
    mesonEnable
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ;
  inherit (lib.trivial)
    importJSON
    ;

  info = importJSON ./info.json;

  # possibility to add more adapters in the future, such as keepDebugInfo,
  # which would be controlled by the `debug` flag
  # Condition on darwin to avoid breaking eval for darwin in CI,
  # even though darwin is not supported anyway.
<<<<<<< HEAD
  adapters = lib.optionals (!gcc15Stdenv.targetPlatform.isDarwin) [
    stdenvAdapters.useMoldLinker
  ];

  customStdenv = foldl' (acc: adapter: adapter acc) gcc15Stdenv adapters;
=======
  adapters = lib.optionals (!stdenv.targetPlatform.isDarwin) [
    stdenvAdapters.useMoldLinker
  ];

  customStdenv = foldl' (acc: adapter: adapter acc) stdenv adapters;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
assert assertMsg (!nvidiaPatches) "The option `nvidiaPatches` has been removed.";
assert assertMsg (!enableNvidiaPatches) "The option `enableNvidiaPatches` has been removed.";
assert assertMsg (!hidpiXWayland)
  "The option `hidpiXWayland` has been removed. Please refer https://wiki.hyprland.org/Configuring/XWayland";
assert assertMsg (
  !legacyRenderer
) "The option `legacyRenderer` has been removed. Legacy renderer is no longer supported.";

customStdenv.mkDerivation (finalAttrs: {
  pname = "hyprland" + optionalString debug "-debug";
<<<<<<< HEAD
  version = "0.53.0";
=======
  version = "0.52.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-1jZK7hqNhQRqhj+2eb/JvnBoARxUgoVXKLSwp2RPmNQ=";
=======
    hash = "sha256-Lr8kwriXtUxjYsi1sGRMIR2LZilgrxYQA1TTmbpSJ+g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp

    # Remove extra @PREFIX@ to fix pkg-config paths
    sed -i "s#@PREFIX@/##g" hyprland.pc.in
<<<<<<< HEAD
    sed -i "s#@PREFIX@/##g" example/hyprland.desktop.in
  '';

  # variables used by CMake, and shown in `hyprctl version`
  env = {
    GIT_BRANCH = info.branch;
    GIT_COMMITS = info.commit_hash;
    GIT_COMMIT_DATE = info.date;
    GIT_DIRTY = "clean";
    GIT_COMMIT_HASH = info.commit_hash;
    GIT_COMMIT_MESSAGE = info.commit_message;
    GIT_TAG = info.tag;
  };
=======
  '';

  # variables used by generateVersion.sh script, and shown in `hyprctl version`
  BRANCH = info.branch;
  COMMITS = info.commit_hash;
  DATE = info.date;
  DIRTY = "";
  HASH = info.commit_hash;
  MESSAGE = info.commit_message;
  TAG = info.tag;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  depsBuildBuild = [
    # to find wayland-scanner when cross-compiling
    pkg-config
  ];

  nativeBuildInputs = [
    hyprwayland-scanner
<<<<<<< HEAD
    hyprwire
    makeWrapper
    cmake
    # meson + ninja are used to build the hyprland-protocols submodule
=======
    makeWrapper
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    meson
    ninja
    pkg-config
    wayland-scanner
    # for udis86
<<<<<<< HEAD
=======
    cmake
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
      git
      hyprcursor.dev
      hyprgraphics
      hyprlang
      hyprutils
      libGL
      libdrm
      libinput
      libuuid
      libxkbcommon
      libgbm
<<<<<<< HEAD
      muparser
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      pango
      pciutils
      re2
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

<<<<<<< HEAD
  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";
=======
  mesonBuildType = if debug then "debug" else "release";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontStrip = debug;
  strictDeps = true;

<<<<<<< HEAD
  cmakeFlags = mapAttrsToList cmakeBool {
    "BUILT_WITH_NIX" = true;
    "NO_XWAYLAND" = !enableXWayland;
    "NO_SYSTEMD" = !withSystemd;
    "CMAKE_DISABLE_PRECOMPILE_HEADERS" = true;
    "NO_UWSM" = true;
    "NO_HYPRPM" = true;
    "TRACY_ENABLE" = false;
  };
=======
  mesonFlags = concatLists [
    (mapAttrsToList mesonEnable {
      "xwayland" = enableXWayland;
      "systemd" = withSystemd;
      "uwsm" = false;
      "hyprpm" = false;
    })
    (mapAttrsToList mesonBool {
      # PCH provides no benefits when building with Nix
      "b_pch" = false;
      "tracy_enable" = false;
    })
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
    providedSessions = [ "hyprland" ];
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
