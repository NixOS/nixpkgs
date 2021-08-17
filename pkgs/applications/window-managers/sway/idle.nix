{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, systemd
}:

stdenv.mkDerivation rec {
  pname = "swayidle";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swayidle";
    rev = version;
    sha256 = "0ziya8d5pvvxg16jhy4i04pvq11bdvj68gz5q654ar4dldil17nn";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols systemd ];

  mesonFlags = [ "-Dman-pages=enabled" "-Dlogind=enabled" ];

  meta = with lib; {
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
