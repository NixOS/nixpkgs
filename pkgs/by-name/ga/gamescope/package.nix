{ stdenv
, edid-decode
, fetchFromGitHub
, meson
, pkg-config
, ninja
, cmake
, xorg
, libdrm
, libei
, vulkan-loader
, vulkan-headers
, wayland
, wayland-protocols
, libxkbcommon
, glm
, gbenchmark
, libcap
, libavif
, SDL2
, pipewire
, pixman
, python3
, libinput
, glslang
, hwdata
, stb
, wlroots
, libdecor
, lcms
, lib
, makeBinaryWrapper
, patchelfUnstable
, nix-update-script
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
  version = "3.14.29";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    rev = "refs/tags/${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-q3HEbFqUeNczKYUlou+quxawCTjpM5JNLrML84tZVYE=";
  };

  patches = [
    # Make it look for shaders in the right place
    ./shaders-path.patch
    # patch relative gamescopereaper path with absolute
    ./gamescopereaper.patch
  ];

  # We can't substitute the patch itself because substituteAll is itself a derivation,
  # so `placeholder "out"` ends up pointing to the wrong place
  postPatch = ''
    substituteInPlace src/reshade_effect_manager.cpp --replace "@out@" "$out"
    # Patching shebangs in the main `libdisplay-info` build
    patchShebangs subprojects/libdisplay-info/tool/gen-search-table.py
    # Replace gamescopereeaper with absolute path
    substituteInPlace src/Utils/Process.cpp --subst-var-by "gamescopereaper" "$out/bin/gamescopereaper"
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
    # For `libdisplay-info`
    python3
    hwdata
    edid-decode
    # For OpenVR
    cmake
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
    glm
  ] ++ lib.optionals enableWsi [
    vulkan-headers
  ] ++ lib.optionals enableExecutable (wlroots.buildInputs ++ [  # gamescope uses a custom wlroots branch
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
    libavif
    libdrm
    libei
    SDL2
    libdecor
    libinput
    libxkbcommon
    gbenchmark
    pixman
    libcap
    stb
    lcms
  ]);

  postInstall = lib.optionalString enableExecutable ''
    # using patchelf unstable because the stable version corrupts the binary
    ${lib.getExe patchelfUnstable} $out/bin/gamescope \
      --add-rpath ${vulkan-loader}/lib --add-needed libvulkan.so.1

    # --debug-layers flag expects these in the path
    wrapProgram "$out/bin/gamescope" \
      --prefix PATH : ${with xorg; lib.makeBinPath [xprop xwininfo]}

    # Install ReShade shaders
    mkdir -p $out/share/gamescope/reshade
    cp -r ${joshShaders}/* $out/share/gamescope/reshade/
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    description = "SteamOS session compositing window manager";
    homepage = "https://github.com/ValveSoftware/gamescope";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nrdxp pedrohlc Scrumplex zhaofengli k900 ];
    platforms = platforms.linux;
    mainProgram = "gamescope";
  };
})
