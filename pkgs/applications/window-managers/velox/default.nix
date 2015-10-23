{ lib, stdenv, fetchurl, fetchFromGitHub, pkgconfig
, swc, libxkbcommon
, wld, wayland, pixman, fontconfig
}:

stdenv.mkDerivation rec {
  name = "velox-${version}";
  version = "git-2015-09-23";

  src = fetchurl {
    url = "https://github.com/michaelforney/velox/archive/499768b5834967727e3d91139b4013b6aca95762.tar.gz";
    sha256 = "252959f0f0ff593c187449b61c234c214fdf321e3f4e8b5d9e3c2949d932a0a2";
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
