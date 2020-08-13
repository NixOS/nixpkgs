{ stdenv, fetchFromGitHub, meson, pkg-config, ninja
, pixman, libxkbcommon, wayland, neatvnc, libdrm, libX11, aml
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ddcf8hrxhx4rcwvbjwa5j3ygiwca2dpw26wl37pb0q0jr81wylv";
  };

  nativeBuildInputs = [ meson pkg-config ninja wayland ];
  buildInputs = [ pixman libxkbcommon wayland neatvnc libdrm libX11 aml ];

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
    changelog = "https://github.com/any1/wayvnc/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
