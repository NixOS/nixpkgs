{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja, scdoc, wayland-scanner
, pixman, libxkbcommon, wayland, neatvnc, libdrm, libX11, aml, pam, mesa
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-/OKkQKt43lR0UCmQeSDMl1hXh03k+dX3UweigMWEUx4=";
  };

  nativeBuildInputs = [ meson pkg-config ninja scdoc wayland-scanner ];
  buildInputs = [ pixman libxkbcommon wayland neatvnc libdrm libX11 aml pam mesa ];

  meta = with lib; {
    description = "A VNC server for wlroots based Wayland compositors";
    longDescription = ''
      This is a VNC server for wlroots based Wayland compositors. It attaches
      to a running Wayland session, creates virtual input devices and exposes a
      single display via the RFB protocol. The Wayland session may be a
      headless one, so it is also possible to run wayvnc without a physical
      display attached.
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/any1/wayvnc/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
  };
}
