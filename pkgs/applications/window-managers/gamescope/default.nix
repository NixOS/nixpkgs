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
, wayland-scanner
, wayland-protocols
, libxkbcommon
, glm
, gbenchmark
, libcap
, SDL2
, pipewire
, udev
, pixman
, libinput
, seatd
, xwayland
, glslang
, hwdata
, openvr
, stb
, wlroots
, libliftoff
, libdisplay-info
, spirv-headers
, lib
, makeBinaryWrapper
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gamescope";
  version = "3.13.19";

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-US9S97ce8WuEi6mk2yyi9etsUNPUH2ypPTxdaMXM7cI=";
  };

  vkroots = fetchFromGitHub {
    owner = "Joshua-Ashton";
    repo = "vkroots";
    rev = "d5ef31abc7cb5c69aee4bcb67b10dd543c1ff7ac";
    hash = "sha256-gNlSEeqy8svxrcUt1gYBacpjzdnfKS89yb//DiiCVTw=";
  };

  # equivalent to Joshua-Ashton/reshade/9fdbea6892f9959fdc18095d035976c574b268b7
  # See https://github.com/crosire/reshade/pull/267
  reshade = fetchFromGitHub {
    owner = "crosire";
    repo = "reshade";
    rev = "5c8b8f0993a46fcd2f471181b002fb7f549c33c5";
    hash = "sha256-73xoFoZeCIToxC42IdpMCEqajDM0JBEDSVfsZ4VUuQQ=";
  };

  patches = [
    ./use-pkgconfig.patch
  ];

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    wayland-scanner
    glslang
    makeBinaryWrapper
  ];

  buildInputs = [
    xorg.libXdamage
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXrender
    xorg.libXext
    xorg.libXxf86vm
    xorg.libXtst
    xorg.libXres
    xorg.libXi
    xorg.libXmu
    libdrm
    libliftoff
    vulkan-loader
    vulkan-headers
    SDL2
    wayland
    wayland-protocols
    wlroots
    xwayland
    seatd
    libinput
    libxkbcommon
    glm
    gbenchmark
    udev
    pixman
    pipewire
    libcap
    stb
    hwdata
    openvr
    libdisplay-info
  ];

  outputs = [ "out" "lib" ];

  # HACK: We should ideally use pkg-config for all of these, but Gamescope doesn't look for (most of) these using pkg-config
  postUnpack = ''
    rm -rf source/subprojects/vkroots
    ln -s ${finalAttrs.vkroots} source/subprojects/vkroots
    rm -rf source/src/reshade
    ln -s ${finalAttrs.reshade} source/src/reshade
    rm -rf source/thirdparty/SPIRV-Headers
    ln -s ${spirv-headers} source/thirdparty/SPIRV-Headers
  '';

  # --debug-layers flag expects these in the path
  postInstall = ''
    wrapProgram "$out/bin/gamescope" \
      --prefix PATH : ${with xorg; lib.makeBinPath [xprop xwininfo]}

    # Install Vulkan layer in lib output
    install -d $lib/share/vulkan
    mv $out/share/vulkan/implicit_layer.d $lib/share/vulkan
    rm -r $out/share/vulkan
  '';

  meta = with lib; {
    description = "SteamOS session compositing window manager";
    homepage = "https://github.com/ValveSoftware/gamescope";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nrdxp pedrohlc Scrumplex zhaofengli ];
    platforms = platforms.linux;
    mainProgram = "gamescope";
  };
})
