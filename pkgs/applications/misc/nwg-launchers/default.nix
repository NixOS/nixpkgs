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
, gtk-layer-shell
}:

stdenv.mkDerivation rec {
  pname = "nwg-launchers";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QWDYy0TBxoYxfRAOtAEVM8wsPUi2SnzMXsu38guAURU=";
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
    gtk-layer-shell
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
