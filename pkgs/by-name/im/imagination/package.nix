{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  docbook_xsl,
  ffmpeg-full,
  glib,
  gtk3,
  intltool,
  libxslt,
  pkg-config,
  sox,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "imagination";
  version = "3.6";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "139dgb9vfr2q7bxvjskykdz526xxwrn0bh463ir8m2p7rx5a3pw5";
  };

  nativeBuildInputs = [
    autoreconfHook
    docbook_xsl
    intltool
    libxslt
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    ffmpeg-full
    glib
    gtk3
    sox
  ];

  preBuild = ''
    substituteInPlace src/main-window.c \
      --replace 'gtk_icon_theme_load_icon(icon_theme,"image", 20, 0, NULL)' \
      'gtk_icon_theme_load_icon(icon_theme,"insert-image", 20, 0, NULL)' \
      --replace 'gtk_icon_theme_load_icon(icon_theme,"sound", 20, 0, NULL)' \
      'gtk_icon_theme_load_icon(icon_theme,"audio-x-generic", 20, 0, NULL)'
  '';

  preFixup = ''
    gappsWrapperArgs+=(
       --prefix PATH : "${
         lib.makeBinPath [
           ffmpeg-full
           sox
         ]
       }"
    )
  '';

  meta = with lib; {
    description = "Lightweight and simple DVD slide show maker";
    homepage = "https://imagination.sourceforge.net";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ austinbutler ];
    platforms = platforms.linux;
    mainProgram = "imagination";
  };
}
