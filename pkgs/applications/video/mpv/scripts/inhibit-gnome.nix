{ lib, stdenv, fetchFromGitHub, gitUpdater, pkg-config, dbus, mpv-unwrapped }:

stdenv.mkDerivation rec {
  pname = "mpv-inhibit-gnome";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "Guldoman";
    repo = "mpv_inhibit_gnome";
    rev = "v${version}";
    hash = "sha256-LSGg5gAQE2JpepBqhz6D6d3NlqYaU4bjvYf1F+oLphQ=";
  };
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus mpv-unwrapped ];

  passthru.scriptName = "mpv_inhibit_gnome.so";

  installPhase = ''
    install -D ./lib/mpv_inhibit_gnome.so $out/share/mpv/scripts/mpv_inhibit_gnome.so
  '';

  meta = with lib; {
    description = "This mpv plugin prevents screen blanking in GNOME";
    homepage = "https://github.com/Guldoman/mpv_inhibit_gnome";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ myaats ];
  };
}
