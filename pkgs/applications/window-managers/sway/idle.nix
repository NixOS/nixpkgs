{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, systemd
}:

stdenv.mkDerivation rec {
  name = "swayidle-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    sha256 = "1xmcd5wajyrxc8171pl7vhxqg4da482k5n1h0x1j9n07wz50wjqm";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols systemd ];

  meta = with stdenv.lib; {
    description = "Idle management daemon for Wayland";
    longDescription = ''
      Sway's idle management daemon. It is compatible with any Wayland
      compositor which implements the KDE idle protocol.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
