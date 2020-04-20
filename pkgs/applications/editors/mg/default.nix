{ stdenv, fetchFromGitHub, pkgconfig, ncurses, buildPackages, libbsd }:

stdenv.mkDerivation rec {
  pname = "mg";
  version = "20200215";

  src = fetchFromGitHub {
    owner = "hboetes";
    repo = "mg";
    rev = "20200215";
    sha256 = "1rss7d43hbq43n63gxfvx4b2vh2km58cchwzdf2ssqhaz3qj40m6";
  };

  enableParallelBuilding = true;

  makeFlags = [ "PKG_CONFIG=${buildPackages.pkgconfig}/bin/pkg-config" ];

  installPhase = ''
    install -m 555 -Dt $out/bin mg
    install -m 444 -Dt $out/share/man/man1 mg.1
  '';
  nativeBuildInputs = [ pkgconfig ];

  patches = ./darwin_no_libbsd.patch;

  buildInputs = [ ncurses ] ++ stdenv.lib.optional (!stdenv.isDarwin) libbsd;

  meta = with stdenv.lib; {
    description = "Micro GNU/emacs, a portable version of the mg maintained by the OpenBSD team";
    homepage = "https://homepage.boetes.org/software/mg";
    license = licenses.publicDomain;
    platforms = platforms.all;
  };
}
