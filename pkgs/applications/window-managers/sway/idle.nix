{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, scdoc
, wayland, wayland-protocols, systemd
}:

stdenv.mkDerivation rec {
  pname = "swayidle";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    sha256 = "1nd3v8r9549lykdwh4krldfl59lzaspmmai5k1icy7dvi6kkr18r";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "version: '1.5'" "version: '${version}'"
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
