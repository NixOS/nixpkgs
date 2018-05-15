{ stdenv, fetchFromGitHub, cmake, pkgconfig, glib, gettext, readline }:

stdenv.mkDerivation rec {
  name = "sdcv-${version}";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Dushistov";
    repo = "sdcv";
    rev = "v${version}";
    sha256 = "1b67s4nj0s5fh3cjk7858qvhiisc557xx72xwzrb8hq6ijpwx5k0";
  };

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ glib gettext readline ];

  preInstall = ''
    mkdir locale
  '';

  NIX_CFLAGS_COMPILE = "-D__GNU_LIBRARY__";

  meta = with stdenv.lib; {
    homepage = https://dushistov.github.io/sdcv/;
    description = "Console version of StarDict";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
