{ stdenv, fetchFromGitHub, meson, pkg-config, ninja
, pixman, libuv, libGL, libxkbcommon, wayland, neatvnc, libdrm, libX11
}:

stdenv.mkDerivation rec {
  pname = "wayvnc";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "any1";
    repo = pname;
    rev = "v${version}";
    sha256 = "0aa12fkbwhzs0g2pqw1b27l33nn5dpbcvsf1z8h88kwsf9xdvb2r";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "version: '0.1.0'" "version: '${version}'"
  '';

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
    changelog = "https://github.com/any1/wayvnc/releases/tag/v${version}";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
