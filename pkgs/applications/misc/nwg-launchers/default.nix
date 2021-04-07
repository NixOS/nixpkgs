{ lib, stdenv
, fetchFromGitHub
, cmake
, gtkmm3
, meson
, ninja
, nlohmann_json
, pkg-config
, swaylock
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "nwg-launchers";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-krhFtFQZSwfKPHmVxPGNySPL2Y9+kA0fxjZ/D+mNks4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    gtkmm3
    nlohmann_json
  ];

  postInstall = ''
    wrapProgram $out/bin/nwgbar \
      --prefix PATH : "${swaylock}/bin"
  '';

  meta = with lib; {
    description = "GTK-based launchers: application grid, button bar, dmenu for sway and other window managers";
    homepage = "https://github.com/nwg-piotr/nwg-launchers";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bbigras ];
  };
}
