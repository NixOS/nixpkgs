{ lib, stdenv, fetchurl, perl, libX11, libXinerama, libjpeg, libpng, libtiff, libwebp, pkg-config,
librsvg, glib, gtk2, libXext, libXxf86vm, poppler, vlc, ghostscript, makeWrapper, tzdata }:

stdenv.mkDerivation rec {
  pname = "eaglemode";
  version = "0.96.0";

  src = fetchurl {
    url = "mirror://sourceforge/eaglemode/${pname}-${version}.tar.bz2";
    hash = "sha256-aMVXJpfws9rh2Eaa/EzSLwtwvn0pVJlEbhxzvXME1hs=";
  };

  # Fixes "Error: No time zones found." on the clock
  postPatch = ''
    substituteInPlace src/emClock/emTimeZonesModel.cpp --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"
  '';

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ perl libX11 libXinerama libjpeg libpng libtiff libwebp
    librsvg glib gtk2 libXxf86vm libXext poppler vlc ghostscript ];

  # The program tries to dlopen Xxf86vm, Xext and Xinerama, so we use the
  # trick on NIX_LDFLAGS and dontPatchELF to make it find them.
  buildPhase = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lXxf86vm -lXext -lXinerama"
    perl make.pl build
  '';

  dontPatchELF = true;
  # eaglemode expects doc to be in the root directory
  forceShare = [ "man" "info" ];

  installPhase = ''
    perl make.pl install dir=$out
    wrapProgram $out/bin/eaglemode --set EM_DIR "$out" --prefix LD_LIBRARY_PATH : "$out/lib" --prefix PATH : "${ghostscript}/bin"
  '';

  meta = with lib; {
    homepage = "http://eaglemode.sourceforge.net";
    description = "Zoomable User Interface";
    changelog = "https://eaglemode.sourceforge.net/ChangeLog.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
