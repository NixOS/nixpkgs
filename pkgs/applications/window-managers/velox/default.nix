{ lib, stdenv, fetchurl, fetchFromGitHub, pkgconfig
, swc, libxkbcommon
, wld, wayland, pixman, fontconfig
}:

stdenv.mkDerivation rec {
  name = "velox-${version}";
  version = "git-2015-11-03";
  repo = "https://github.com/michaelforney/velox";
  rev = "53b41348df7e37886cab012609923255e4397419";

  src = fetchurl {
    url = "${repo}/archive/${rev}.tar.gz";
    sha256 = "e49583efbbe62ea30f0084491ff757dff683f35eef6e9b68aa413e0b50c4bf20";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ swc libxkbcommon wld wayland pixman fontconfig ];

  makeFlags = "PREFIX=$(out)";
  installPhase = "PREFIX=$out make install";

  meta = {
    description = "velox window manager";
    homepage    = "https://github.com/michaelforney/velox";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
