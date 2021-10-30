{ lib, stdenv, fetchFromGitHub, meson, pkg-config, ninja, scdoc, wayland-scanner
, pixman, libxkbcommon, wayland, neatvnc, libdrm, libX11, aml, pam
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q48fgh6gf3jicy4bk3kq18h9lhqfq9qz32ri6j9ffvbb8mcw64s";
  };

  nativeBuildInputs = [ meson pkg-config ninja scdoc wayland-scanner ];
  buildInputs = [ pixman libxkbcommon wayland neatvnc libdrm libX11 aml pam ];

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
    maintainers = with maintainers; [ primeos ];
  };
}
