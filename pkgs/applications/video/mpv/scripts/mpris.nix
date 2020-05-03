{ stdenv, fetchFromGitHub, pkgconfig, gobject-introspection, mpv }:

stdenv.mkDerivation rec {
  name = "mpv-mpris-${version}.so";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = version;
    sha256 = "07p6li5z38pkfd40029ag2jqx917vyl3ng5p2i4v5a0af14slcnk";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gobject-introspection mpv ];

  installPhase = ''
    cp mpris.so $out
  '';

  meta = with stdenv.lib; {
    description = "MPRIS plugin for mpv";
    homepage = "https://github.com/hoyon/mpv-mpris";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
