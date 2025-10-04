{
  lib,
  stdenv,
  fetchFromGitea,
  pkg-config,
  gtk3,
  file,
  lcms2,
  libexif,
}:

stdenv.mkDerivation (rec {
  pname = "qiv";
  version = "3.0.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "ciberandy";
    repo = "qiv";
    tag = "v${version}";
    hash = "sha256-U++ZyJ0cVa5x/1Me7Em1W33jAYe3Q/TfMZgPj71ZaFA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk3
    file
    lcms2
    libexif
  ];

  preBuild = ''
    substituteInPlace Makefile --replace /usr/local "$out"
    substituteInPlace Makefile --replace /man/ /share/man/
    substituteInPlace Makefile --replace /share/share/ /share/
  '';

  meta = with lib; {
    description = "Quick image viewer";
    homepage = "http://spiegl.de/qiv/";
    license = licenses.gpl2;
    platforms = platforms.linux;
    mainProgram = "qiv";
  };
})
