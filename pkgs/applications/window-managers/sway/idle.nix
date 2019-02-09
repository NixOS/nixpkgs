{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, systemd
}:

stdenv.mkDerivation rec {
  name = "swayidle-${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    sha256 = "0b65flajwn2i6k2kdxxgw25w7ikzzmm595f4j5x1wac1rb0yah9w";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ wayland wayland-protocols systemd ];

  mesonFlags = [ "-Dman-pages=enabled" "-Dlogind=enabled" ];

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
