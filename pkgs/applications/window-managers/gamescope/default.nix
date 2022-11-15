{ stdenv
, fetchFromGitHub
, meson
, pkg-config
, ninja
, xorg
, libdrm
, vulkan-loader
, wayland
, wayland-protocols
, libxkbcommon
, libcap
, SDL2
, pipewire
, udev
, pixman
, libinput
, seatd
, xwayland
, glslang
, stb
, wlroots
, libliftoff
, lib
, makeBinaryWrapper
}:
let
  pname = "gamescope";
  version = "3.11.48";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Plagman";
    repo = "gamescope";
    rev = "refs/tags/${version}";
    hash = "sha256-/a0fW0NVIrg9tuK+mg+D+IOcq3rJJxKdFwspM1ZRR9M=";
  };

  patches = [ ./use-pkgconfig.patch ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
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
    libdrm
    libliftoff
    vulkan-loader
    glslang
    SDL2
    wayland
    wayland-protocols
    wlroots
    xwayland
    seatd
    libinput
    libxkbcommon
    udev
    pixman
    pipewire
    libcap
    stb
  ];

  # --debug-layers flag expects these in the path
  postInstall = ''
    wrapProgram "$out/bin/gamescope" \
     --prefix PATH : ${with xorg; lib.makeBinPath [xprop xwininfo]}
  '';

  meta = with lib; {
    description = "SteamOS session compositing window manager";
    homepage = "https://github.com/Plagman/gamescope";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nrdxp ];
    platforms = platforms.linux;
  };
}
