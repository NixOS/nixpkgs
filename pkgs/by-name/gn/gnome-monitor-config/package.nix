{ lib
, fetchFromGitHub
, stdenv
, meson
, ninja
, pkg-config
, cairo
, glib
}:

stdenv.mkDerivation rec {
  pname = "gnome-monitor-config";
  version = "0-unstable-2023-09-26";

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

  buildInputs = [
    cairo
    glib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv src/gnome-monitor-config $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Program to help manage GNOME monitor configuration";
    homepage = "https://github.com/jadahl/gnome-monitor-config";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aveltras ];
    platforms = platforms.linux;
    mainProgram = "gnome-monitor-config";
  };
}
