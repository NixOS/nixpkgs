{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, gtk3, wxGTK32
, curl, gettext, glib, indi-full, libnova, wrapGAppsHook3 }:

stdenv.mkDerivation rec {
  pname = "phd2";
  version = "2.6.13";

  src = fetchFromGitHub {
    owner = "OpenPHDGuiding";
    repo = "phd2";
    rev = "v${version}";
    sha256 = "sha256-GnT/tyk975caqESBSu4mdX5IWGi5O+RljLSd+CwoGWo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    wxGTK32
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
