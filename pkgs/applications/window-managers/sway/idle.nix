{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, systemd
}:

stdenv.mkDerivation rec {
  name = "swayidle-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    sha256 = "04agcbhc473jkk7npb40i94ny8naykxzpjcw2lvl05kxv65y5d9v";
  };

  postPatch = ''
    sed -iE "s/version: '1\.2',/version: '${version}',/" meson.build
  '';

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
