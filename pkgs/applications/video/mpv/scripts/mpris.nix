{ stdenv, fetchFromGitHub, pkgconfig, gobjectIntrospection, mpv }:

stdenv.mkDerivation rec {
  name = "mpv-mpris-${version}.so";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = "v${version}";
    sha256 = "0rsbrbv5q7vki59wdlx4cdkd0vvd79qgbjvdb3fn3li7aznvjwiy";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gobjectIntrospection mpv ];

  installPhase = ''
    cp mpris.so $out
  '';

  meta = with stdenv.lib; {
    description = "MPRIS plugin for mpv";
    homepage = https://github.com/hoyon/mpv-mpris;
    license = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
