{ stdenv, fetchFromGitHub, meson, pkg-config, ninja
, pixman, libuv, libGL, libxkbcommon, wayland, neatvnc, libdrm, libX11
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "17c30c33zzhhlqzc4a5dd1y74ch7c8gsm98wvcn4n1fv50fbmpbd";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ pixman libuv libGL libxkbcommon wayland neatvnc libdrm libX11 ];

  meta = with stdenv.lib; {
    description = "A VNC server for wlroots based Wayland compositors";
    longDescription = ''
      This is a VNC server for wlroots based Wayland compositors. It attaches
      to a running Wayland session, creates virtual input devices and exposes a
      single display via the RFB protocol. The Wayland session may be a
      headless one, so it is also possible to run wayvnc without a physical
      display attached.
    '';
    inherit (src.meta) homepage;
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
