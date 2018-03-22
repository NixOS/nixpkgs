{ lib, stdenv, fetchFromGitHub, pkgconfig
, wld, wayland, wayland-protocols, fontconfig, pixman, libdrm, libinput, libevdev, libxkbcommon, libxcb, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "swc-${version}";
  version = "git-2017-06-28";

  src = fetchFromGitHub {
    owner = "michaelforney";
    repo = "swc";
    rev = "5b20050872f8ad29cfc97729f8af47b6b3df5393";
    sha256 = "1lxpm17v5d8png6ixc0zn0w00xgrhz2n5b8by9vx6800b18246z8";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ wld wayland wayland-protocols fontconfig pixman libdrm libinput libevdev libxkbcommon libxcb xcbutilwm ];

  prePatch = ''
    substituteInPlace launch/local.mk --replace 4755 755
  '';

  makeFlags = "PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  enableParallelBuilding = true;

  meta = {
    description = "A library for making a simple Wayland compositor";
    homepage    = src.meta.homepage;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
