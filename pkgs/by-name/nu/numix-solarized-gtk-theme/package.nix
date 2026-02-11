{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  sassc,
  glib,
  gdk-pixbuf,
  inkscape,
  gtk-engine-murrine,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "numix-solarized-gtk-theme";
  version = "20230408";

  src = fetchFromGitHub {
    owner = "Ferdi265";
    repo = "numix-solarized-gtk-theme";
    rev = finalAttrs.version;
    sha256 = "sha256-r5xCe8Ew+/SuCUaZ0yjlumORTy/y1VwbQQjQ6uEyGsY=";
  };

  nativeBuildInputs = [
    python3
    sassc
    glib
    gdk-pixbuf
    inkscape
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace '$(DESTDIR)'/usr $out
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    for theme in colors/*.colors; do
      theme="''${theme##*/}"
      make THEME="''${theme/.colors/}" install
    done
    runHook postInstall
  '';

  meta = {
    description = "Solarized versions of Numix GTK2 and GTK3 theme";
    longDescription = ''
      This is a fork of the Numix GTK theme that replaces the colors of the theme
      and icons to use the solarized theme with a solarized green accent color.
      This theme supports both the dark and light theme, just as Numix proper.
    '';
    homepage = "https://github.com/Ferdi265/numix-solarized-gtk-theme";
    downloadPage = "https://github.com/Ferdi265/numix-solarized-gtk-theme/releases";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.offline ];
  };
})
