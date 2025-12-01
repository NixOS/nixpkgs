{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk_engines,
}:

stdenv.mkDerivation {
  version = "2016-08-16";
  pname = "paper-gtk-theme";

  src = fetchFromGitHub {
    owner = "snwh";
    repo = "paper-gtk-theme";
    rev = "f75724fd76fd2e5681a367cca246a51f845320c3";
    sha256 = "0dqllzjk9ggnbh8vvy2c81p3wq6cj73r30hk7gqhrn8i91w8p896";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ gtk_engines ];

  postPatch = ''
    substituteInPlace Makefile.am --replace '$(DESTDIR)'/usr $out
  '';

  meta = with lib; {
    description = "Modern desktop theme suite featuring a mostly flat with a minimal use of shadows for depth";
    homepage = "https://snwh.org/paper";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [
      maintainers.simonvandel
      maintainers.romildo
    ];
  };
}
