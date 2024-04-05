{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, makeWrapper
, meson
, ninja
, binutils
, cairo
, git
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
, systemd
, tomlplusplus
, udis86
, wayland
, wayland-protocols
, wayland-scanner
, wlroots
, xcbutilwm
, xwayland
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
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-oZe4k6jtO/0govmERGcbeyvE9EfTvXY5bnyIs6AsL9U=";
  };

  patches = [
    # make meson use the provided dependencies instead of the git submodules
    "${finalAttrs.src}/nix/patches/meson-build.patch"
  ];

  postPatch = ''
    # Fix hardcoded paths to /usr installation
    sed -i "s#/usr#$out#" src/render/OpenGL.cpp

    # Generate version.h
    cp src/version.h.in src/version.h
    substituteInPlace src/version.h \
      --replace "@HASH@" '${finalAttrs.src.rev}' \
      --replace "@BRANCH@" "" \
      --replace "@MESSAGE@" "" \
      --replace "@DATE@" "2024-02-05" \
      --replace "@TAG@" "" \
      --replace "@DIRTY@" ""
  '';

  nativeBuildInputs = [
    jq
    makeWrapper
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
      hyprlang
      libGL
      libdrm
      libinput
      libxkbcommon
      mesa
      udis86
      wayland
      wayland-protocols
      pango
      pciutils
      tomlplusplus
      wlroots
    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [ libexecinfo ]
    ++ lib.optionals enableXWayland [ libxcb xcbutilwm xwayland ]
    ++ lib.optionals withSystemd [ systemd ];

  mesonBuildType =
    if debug
    then "debug"
    else "release";

  mesonAutoFeatures = "disabled";

  mesonFlags = [
    (lib.mesonEnable "xwayland" enableXWayland)
    (lib.mesonEnable "legacy_renderer" legacyRenderer)
    (lib.mesonEnable "systemd" withSystemd)
  ];

  postInstall = ''
    ln -s ${wlroots}/include/wlr $dev/include/hyprland/wlroots
    ${lib.optionalString wrapRuntimeDeps ''
      wrapProgram $out/bin/Hyprland \
        --suffix PATH : ${lib.makeBinPath [binutils pciutils stdenv.cc]}
    ''}
  '';

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
