{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, gtk3, wxGTK30-gtk3
, curl, gettext, glib, indi-full, libnova, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "phd2";
  version = "2.6.11";

  src = fetchFromGitHub {
    owner = "OpenPHDGuiding";
    repo = "phd2";
    rev = "v${version}";
    sha256 = "sha256-iautgHOVzdLWYGOVu3wHBDt30uCbaP58mDz/l7buB1k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    wxGTK30-gtk3
    curl
    gettext
    glib
    indi-full
    libnova
  ];

  cmakeFlags = [
    "-DOPENSOURCE_ONLY=1"
  ];

  # Fix broken wrapped name scheme by moving wrapped binary to where wrapper expects it
  postFixup = ''
    mv $out/bin/.phd2.bin-wrapped $out/bin/.phd2-wrapped.bin
  '';

  meta = with lib; {
    homepage = "https://openphdguiding.org/";
    description = "Telescope auto-guidance application";
    changelog = "https://github.com/OpenPHDGuiding/phd2/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hjones2199 ];
    platforms = platforms.linux;
  };
}
