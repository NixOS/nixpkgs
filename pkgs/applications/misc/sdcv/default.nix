{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, glib, gettext, readline }:

stdenv.mkDerivation rec {
  pname = "sdcv";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "Dushistov";
    repo = "sdcv";
    rev = "v${version}";
    sha256 = "144qpl9b8r2php0zhi9b7vg6flpvdgjy6yfaipydwwhxi4wy9600";
  };

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ glib gettext readline ];

  preInstall = ''
    mkdir locale
  '';

  NIX_CFLAGS_COMPILE = "-D__GNU_LIBRARY__";

  meta = with lib; {
    homepage = "https://dushistov.github.io/sdcv/";
    description = "Console version of StarDict";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
