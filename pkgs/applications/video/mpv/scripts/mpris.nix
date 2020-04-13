{ stdenv, fetchFromGitHub, pkgconfig, gobject-introspection, mpv }:

stdenv.mkDerivation rec {
  name = "mpv-mpris-${version}.so";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = version;
    sha256 = "1fr3jvja8s2gdpx8qyk9r17977flms3qpm8zci62nd9r5wjdvr5i";
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
    maintainers = with maintainers; [ jfrankenau ];
  };
}
