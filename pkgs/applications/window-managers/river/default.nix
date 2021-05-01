{ lib, stdenv ,fetchFromGitHub
, wayland-protocols, wlroots, pixman, libxkbcommon, udev, libevdev, libX11, libGL
, zig, wayland, xwayland, pkg-config, scdoc
}:

stdenv.mkDerivation rec {
  pname = "river";
  version = "unstable-2021-04-27";

  src = fetchFromGitHub {
    owner = "ifreund";
    repo = pname;
    rev = "0c8e718d95a6a621b9cba0caa9158915e567b076";
    sha256 = "1jjh0dzxi7hy4mg8vag6ipfwb9qxm5lfc07njp1mx6m81nq76ybk";
    fetchSubmodules = true;
  };

  buildInputs = [
    wayland-protocols
    wlroots
    pixman
    libxkbcommon
    udev
    libevdev
    libX11
    libGL
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';
  installPhase = ''
    runHook preInstall
    zig build -Drelease-safe -Dxwayland -Dman-pages --prefix $out install
    runHook postInstall
  '';

  nativeBuildInputs = [ zig wayland xwayland scdoc pkg-config ];

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/ifreund/river";
    description = "A dynamic tiling wayland compositor";
    longDescription = ''
      river is a dynamic tiling wayland compositor that takes inspiration from dwm and bspwm.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ branwright1 ];
  };
}
