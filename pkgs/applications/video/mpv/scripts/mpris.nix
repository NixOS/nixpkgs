{ stdenv, fetchFromGitHub, pkgconfig, gobject-introspection, mpv }:

stdenv.mkDerivation rec {
  name = "mpv-mpris-${version}.so";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = version;
    sha256 = "06hq3j1jjlaaz9ss5l7illxz8vm5bng86jl24kawglwkqayhdnjx";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gobject-introspection mpv ];

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
