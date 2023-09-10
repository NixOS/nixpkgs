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
, lib
, makeBinaryWrapper
}:
let
  pname = "gamescope";
  version = "3.12.3";

  vkroots = fetchFromGitHub {
    owner = "Joshua-Ashton";
    repo = "vkroots";
    rev = "26757103dde8133bab432d172b8841df6bb48155";
    hash = "sha256-eet+FMRO2aBQJcCPOKNKGuQv5oDIrgdVPRO00c5gkL0=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    rev = "refs/tags/${version}";
    hash = "sha256-eo3c+s+sB20wrzbe2H/pMAYdvKeYOpWwEqmuuLY6ZJA=";
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
    vkroots
    libdisplay-info
  ];

  postUnpack = ''
    rm -rf source/subprojects/vkroots
    ln -s ${vkroots} source/subprojects/vkroots
  '';

  # --debug-layers flag expects these in the path
  postInstall = ''
    wrapProgram "$out/bin/gamescope" \
     --prefix PATH : ${with xorg; lib.makeBinPath [xprop xwininfo]}
  '';

  meta = with lib; {
    description = "SteamOS session compositing window manager";
    homepage = "https://github.com/ValveSoftware/gamescope";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nrdxp pedrohlc Scrumplex zhaofengli ];
    platforms = platforms.linux;
  };
}
