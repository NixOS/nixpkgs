{ stdenv, fetchFromGitHub, meson, pkg-config, ninja, scdoc
, pixman, libxkbcommon, wayland, neatvnc, libdrm, libX11, aml
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vlrk6zdkv0kl1ckxv65nay9vm6yjrs4kadsdvp42nryiifrdhad";
  };

  nativeBuildInputs = [ meson pkg-config ninja scdoc wayland ];
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
