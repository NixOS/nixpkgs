{ lib, stdenv ,fetchFromGitHub
, zig, wayland, pkg-config, scdoc
, xwayland, wayland-protocols, wlroots
, libxkbcommon, pixman, udev, libevdev, libX11, libGL
}:

stdenv.mkDerivation rec {
  pname = "river";
  version = "unstable-2021-04-08";

  src = fetchFromGitHub {
    owner = "ifreund";
    repo = "river";
    rev = "9e3e92050e04320949c6cd995273c30319ebd515";
    sha256 = "1v8dpbadsb3c7bc84sai09dbqv5s5s5d77vs12kdkd45x0ppmk3j";
    fetchSubmodules = true;
  };

  buildInputs = [ xwayland wayland-protocols wlroots pixman
    libxkbcommon pixman udev libevdev libX11 libGL
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';
  installPhase = ''
    zig build -Drelease-safe -Dxwayland -Dman-pages --prefix $out install
   '';

  nativeBuildInputs = [ zig wayland scdoc pkg-config ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "A dynamic tiling wayland compositor";
    longDescription = ''
      river is a dynamic tiling wayland compositor that takes inspiration from dwm and bspwm.
    '';
    homepage = "https://github.com/ifreund/river";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ branwright1 ];
  };
}
