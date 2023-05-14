{ stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "3.11.52-beta6";

  vkroots = fetchFromGitHub {
    owner = "Joshua-Ashton";
    repo = "vkroots";
    rev = "26757103dde8133bab432d172b8841df6bb48155";
    sha256 = "sha256-eet+FMRO2aBQJcCPOKNKGuQv5oDIrgdVPRO00c5gkL0=";
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ValveSoftware";
    repo = "gamescope";
    rev = "refs/tags/${version}";
    hash = "sha256-2gn6VQfmwwl86mmnRh+J1uxSIpA5x/Papq578seJ3n8=";
  };

  patches = [
    ./use-pkgconfig.patch

    # https://github.com/Plagman/gamescope/pull/811
    (fetchpatch {
      name = "fix-openvr-dependency-name.patch";
      url = "https://github.com/Plagman/gamescope/commit/557e56badec7d4c56263d3463ca9cdb195e368d7.patch";
      sha256 = "sha256-9Y1tJ24EsdtZEOCEA30+FJBrdzXX+Nj3nTb5kgcPfBE=";
    })
    # https://github.com/Plagman/gamescope/pull/813
    (fetchpatch {
      name = "fix-openvr-include.patch";
      url = "https://github.com/Plagman/gamescope/commit/1331b9f81ea4b3ae692a832ed85a464c3fd4c5e9.patch";
      sha256 = "sha256-wDtFpM/nMcqSbIpR7K5Tyf0845r3l4kQHfwll1VL4Mc=";
    })
    # https://github.com/Plagman/gamescope/pull/812
    (fetchpatch {
      name = "bump-libdisplay-info-maximum-version.patch";
      url = "https://github.com/Plagman/gamescope/commit/b430c5b9a05951755051fd4e41ce20496705fbbc.patch";
      sha256 = "sha256-YHtwudMUHiE8i3ZbiC9gkSjrlS0/7ydjmJsY1a8ZI2E=";
    })
    # https://github.com/Plagman/gamescope/pull/824
    (fetchpatch {
      name = "update-libdisplay-info-pkgconfig-filename.patch";
      url = "https://github.com/Plagman/gamescope/commit/5a672f09aa07c7c5d674789f3c685c8173e7a2cf.patch";
      sha256 = "sha256-7NX54WIsJDvZT3C58N2FQasV9PJyKkJrLGYS1r4f+kc=";
    })
  ];

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
    xorg.libXmu
    libdrm
    libliftoff
    vulkan-loader
    vulkan-headers
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
