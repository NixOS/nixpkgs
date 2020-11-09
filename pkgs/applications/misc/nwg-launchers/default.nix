{ stdenv
, fetchFromGitHub
, cmake
, gtkmm3
, meson
, ninja
, nlohmann_json
, pkgconfig
, swaylock
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "nwg-launchers";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0flp7mwj1pgcwx3k9pzc8pmqlkhbddj0maimdnvlazk87kzxpfd0";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "GTK-based launchers: application grid, button bar, dmenu for sway and other window managers";
    homepage = "https://github.com/nwg-piotr/nwg-launchers";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bbigras ];
  };
}
