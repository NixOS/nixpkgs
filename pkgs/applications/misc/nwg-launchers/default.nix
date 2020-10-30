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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "0r0wj4w3jj3l56z1lx6ypkzz4fsgx4vzqbvs95661l8q362pndzw";
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
