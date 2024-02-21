{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, pkg-config
, cairo
}:

stdenv.mkDerivation rec {
  pname = "gnome-monitor-config";
  version = "unstable-2023-09-26";

  src = fetchFromGitHub {
    owner = "jadahl";
    repo = "gnome-monitor-config";
    rev = "04b854e6411cd9ca75582c108aea63ae3c202f0e";
    hash = "sha256-uVWhQ5SCyadDkeOd+pY2cYZAQ0ZvWMlgndcr1ZIEf50=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ cairo ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/gnome-monitor-config $out/bin/
  '';

  meta = with lib; {
    description = "CLI tool to configure monitors in gnome";
    homepage = "https://github.com/jadahl/gnome-monitor-config";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ahuzik ];
    platforms = platforms.linux;
  };
}
