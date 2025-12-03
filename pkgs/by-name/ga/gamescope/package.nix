{
  stdenv,
  buildPackages,
  v4l-utils,
  fetchFromGitHub,
  fetchpatch,
  meson,
  pkg-config,
  ninja,
  cmake,
  xorg,
  libdrm,
  libei,
  vulkan-loader,
  vulkan-headers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  glm,
  gbenchmark,
  libcap,
  libavif,
  SDL2,
  pipewire,
  pixman,
  python3,
  libinput,
  glslang,
  hwdata,
  stb,
  wlroots,
  libdecor,
  lcms,
  lib,
  luajit,
  makeBinaryWrapper,
  nix-update-script,
  enableExecutable ? true,
  enableWsi ? true,
}:
let
  frogShaders = fetchFromGitHub {
    owner = "misyltoad";
    repo = "GamescopeShaders";
    rev = "v0.1";
    hash = "sha256-gR1AeAHV/Kn4ntiEDUSPxASLMFusV6hgSGrTbMCBUZA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gamescope";
  version = "3.16.14.5";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-uOsAe7fUkHG+Qy1oguyP+aZlrPm5rbV5YkMJjwJ5lzs=";
  };

  patches = [
    # Make it look for data in the right place
    ./shaders-path.patch
    # patch relative gamescopereaper path with absolute
    ./gamescopereaper.patch

    # Pending upstream patch to allow using system libraries
    # See: https://github.com/ValveSoftware/gamescope/pull/1846
    (fetchpatch {
      url = "https://github.com/ValveSoftware/gamescope/commit/4ce1a91fb219f570b0871071a2ec8ac97d90c0bc.diff";
      hash = "sha256-O358ScIIndfkc1S0A8g2jKvFWoCzcXB/g6lRJamqOI4=";
    })
  ];

  # We can't substitute the patch itself because substituteAll is itself a derivation,
  # so `placeholder "out"` ends up pointing to the wrong place
  postPatch = ''
    substituteInPlace src/reshade_effect_manager.cpp --replace-fail "@out@" "$out"

    # Patching shebangs in the main `libdisplay-info` build
    patchShebangs subprojects/libdisplay-info/tool/gen-search-table.py

    # Replace gamescopereeaper with absolute path
    substituteInPlace src/Utils/Process.cpp --subst-var-by "gamescopereaper" "$out/bin/gamescopereaper"
    patchShebangs default_extras_install.sh
  '';

  mesonFlags = [
    (lib.mesonBool "enable_gamescope" enableExecutable)
    (lib.mesonBool "enable_gamescope_wsi_layer" enableWsi)

    (lib.mesonOption "glm_include_dir" "${lib.getInclude glm}/include")
    (lib.mesonOption "stb_include_dir" "${lib.getInclude stb}/include/stb")
  ];

  # don't install vendored vkroots etc
  mesonInstallFlags = [ "--skip-subprojects" ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wayland-scanner

    # For OpenVR
    cmake

    # calls git describe to encode its own version into the build
    (buildPackages.writeShellScriptBin "git" "echo ${finalAttrs.version}")
  ]
  ++ lib.optionals enableExecutable [
    makeBinaryWrapper
    glslang

    # For `libdisplay-info`
    python3
    hwdata
    v4l-utils
  ];

  buildInputs = [
    pipewire
    hwdata
    xorg.libX11
    xorg.libxcb
    wayland
    wayland-protocols
    vulkan-loader
  ]
  ++ lib.optionals enableWsi [
    vulkan-headers
  ]
  ++ lib.optionals enableExecutable (
    wlroots.buildInputs
    ++ [
      # gamescope uses a custom wlroots branch
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
      lcms
      luajit
    ]
  );

  postInstall = lib.optionalString enableExecutable ''
    # using patchelf unstable because the stable version corrupts the binary
    ${lib.getExe buildPackages.patchelfUnstable} $out/bin/gamescope \
      --add-rpath ${vulkan-loader}/lib --add-needed libvulkan.so.1

    # --debug-layers flag expects these in the path
    wrapProgram "$out/bin/gamescope" \
      --prefix PATH : ${
        with xorg;
        lib.makeBinPath [
          xprop
          xwininfo
        ]
      }

    # Install ReShade shaders
    mkdir -p $out/share/gamescope/reshade
    cp -r ${frogShaders}/* $out/share/gamescope/reshade/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SteamOS session compositing window manager";
    homepage = "https://github.com/ValveSoftware/gamescope";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      pedrohlc
      Scrumplex
      zhaofengli
      k900
      Gliczy
    ];
    platforms = lib.platforms.linux;
    mainProgram = "gamescope";
  };
})
