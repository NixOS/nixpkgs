{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, glib, gettext, readline }:

stdenv.mkDerivation rec {
  pname = "sdcv";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "Dushistov";
    repo = "sdcv";
    rev = "v${version}";
    sha256 = "sha256-i6odmnkoSqDIQAor7Dn26Gu+td9aeMIkwsngF7beBtE=";
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
