{ stdenv
, fetchFromGitHub
, meson
, pkg-config
, ninja
, xorg
, libdrm
, vulkan-loader
, vulkan-headers
, wayland
, wayland-protocols
, libxkbcommon
, glm
, gbenchmark
, libcap
, SDL2
, pipewire
, pixman
, libinput
, glslang
, hwdata
, openvr
, stb
, wlroots
, libliftoff
, libdisplay-info
, lib
, makeBinaryWrapper
, enableExecutable ? true
, enableWsi ? true
}:
let
  joshShaders = fetchFromGitHub {
    owner = "Joshua-Ashton";
    repo = "GamescopeShaders";
    rev = "v0.1";
    hash = "sha256-gR1AeAHV/Kn4ntiEDUSPxASLMFusV6hgSGrTbMCBUZA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gamescope";
  version = "3.13.19";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    rev = "refs/tags/${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-WKQgVbuHvTbZnvTU5imV35AKZ4AF0EDsdESBZwVH7+M=";
  };

  patches = [
    # Unvendor dependencies
    ./use-pkgconfig.patch

    # Make it look for shaders in the right place
    ./shaders-path.patch
  ];

  # We can't substitute the patch itself because substituteAll is itself a derivation,
  # so `placeholder "out"` ends up pointing to the wrong place
  postPatch = ''
    substituteInPlace src/reshade_effect_manager.cpp --replace "@out@" "$out"
  '';

  mesonFlags = [
    (lib.mesonBool "enable_gamescope" enableExecutable)
    (lib.mesonBool "enable_gamescope_wsi_layer" enableWsi)
  ];

  # don't install vendored vkroots etc
  mesonInstallFlags = ["--skip-subprojects"];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ] ++ lib.optionals enableExecutable [
    makeBinaryWrapper
    glslang
  ];

  buildInputs = [
    pipewire
    hwdata
    xorg.libX11
    wayland
    wayland-protocols
    vulkan-loader
    openvr
    glm
  ] ++ lib.optionals enableWsi [
    vulkan-headers
  ] ++ lib.optionals enableExecutable [
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXi
    xorg.libXmu
    xorg.libXrender
    xorg.libXres
    xorg.libXtst
    xorg.libXxf86vm
    libdrm
    libliftoff
    SDL2
    wlroots
    libinput
    libxkbcommon
    gbenchmark
    pixman
    libcap
    stb
    libdisplay-info
  ];

  postInstall = lib.optionalString enableExecutable ''
    # --debug-layers flag expects these in the path
    wrapProgram "$out/bin/gamescope" \
      --prefix PATH : ${with xorg; lib.makeBinPath [xprop xwininfo]}

    # Install ReShade shaders
    mkdir -p $out/share/gamescope/reshade
    cp -r ${joshShaders}/* $out/share/gamescope/reshade/
  '';

  meta = with lib; {
    description = "SteamOS session compositing window manager";
    homepage = "https://github.com/ValveSoftware/gamescope";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nrdxp pedrohlc Scrumplex zhaofengli k900 ];
    platforms = platforms.linux;
    mainProgram = "gamescope";
  };
})
