{ lib
, stdenv
, fetchFromGitLab
, fetchurl
, fetchgit
, ffmpeg
, libGL
, libX11
, libcap
, libdrm
, libinput
, libpng
, libxcb
, libxkbcommon
, mesa
, meson
, ninja
, pandoc
, pixman
, pkg-config
, unzip
, wayland
, wayland-protocols
, xcbutilerrors
, xcbutilimage
, xcbutilwm
}:

let
  # cereal.wrap
  cereal-wrap = fetchurl {
    name = "cereal-1.3.0.tar.gz";
    url = "https://github.com/USCiLab/cereal/archive/v1.3.0.tar.gz";
    hash = "sha256-Mp6j4xMLAmwDpKzFDhaOfa/05uZhvGp9/sDXe1cIUdU=";
  };
  cereal-wrapdb = fetchurl {
    name = "cereal-1.3.0-1-wrap.zip";
    url = "https://wrapdb.mesonbuild.com/v1/projects/cereal/1.3.0/1/get_zip";
    hash = "sha256-QYck5UT7fPLqtLDb1iOSX4Hnnns48Jj23Ae/LCfLSKY=";
  };

  # expected.wrap
  expected-wrap = fetchgit {
    name = "expected";
    url = "https://gitlab.com/cardboardwm/expected";
    rev = "0ee13cb2b058809aa9708c45ca18d494e72a759e";
    sha256 = "sha256-gYr4/pjuLlr3k6Jcrg2/SzJLtbgyA+ZN2oMHkHXANDo=";
  };

  # wlroots.wrap
  wlroots-wrap = fetchgit {
    name = "wlroots";
    url = "https://github.com/swaywm/wlroots";
    rev = "0.12.0";
    sha256 = "sha256-1rE3D+kQprjcjobc95/mQkUa5y1noY0MdoYJ/SpFQwY=";
  };
in
stdenv.mkDerivation rec {
  pname = "cardboard";
  version = "0.pre+unstable=2021-05-10";

  src = fetchFromGitLab {
    owner = "cardboardwm";
    repo = pname;
    rev = "b54758d85164fb19468f5ca52588ebea576cd027";
    hash = "sha256-Kn5NyQSDyX7/nn2bKZPnsuepkoppi5XIkdu7IDy5r4w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pandoc
    pkg-config
    unzip
  ];
  buildInputs = [
    ffmpeg
    libGL
    libX11
    libcap
    libdrm
    libinput
    libpng
    libxcb
    libxkbcommon
    mesa
    pixman
    wayland
    wayland-protocols
    xcbutilerrors
    xcbutilimage
    xcbutilwm
  ];

  postPatch = ''
    (cd subprojects
     tar xvf ${cereal-wrap}
     unzip ${cereal-wrapdb}
     cp -r ${expected-wrap} ${expected-wrap.name}
     cp -r ${wlroots-wrap} ${wlroots-wrap.name}
    )

    sed '1i#include <functional>' -i cardboard/ViewAnimation.h # gcc12
  '';

  # "Inherited" from Nixpkgs expression for wlroots
  mesonFlags = [
    "-Dman=true"
    "-Dwlroots:logind-provider=systemd"
    "-Dwlroots:libseat=disabled"
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=array-bounds" ]; # gcc12

  meta = with lib; {
    homepage = "https://gitlab.com/cardboardwm/cardboard";
    description = "A scrollable, tiling Wayland compositor inspired on PaperWM";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
