{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  sassc,
  gdk-pixbuf,
  librsvg,
  gtk_engines,
  gtk-engine-murrine,
}:

stdenv.mkDerivation rec {
  pname = "stilo-themes";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "lassekongo83";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YKEDXrOAn7pGWb0VcOx7cKHnuX120yPzqtUVnzyLrDQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    sassc
  ];

  buildInputs = [
    gdk-pixbuf
    librsvg
    gtk_engines
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  meta = with lib; {
    description = "Minimalistic GTK, gnome shell and Xfce themes";
    homepage = "https://github.com/lassekongo83/stilo-themes";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
