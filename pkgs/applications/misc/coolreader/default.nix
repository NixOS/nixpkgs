{ mkDerivation, fetchFromGitHub, cmake, pkg-config, lib,
  qttools, fribidi, libunibreak }:

mkDerivation rec {
  pname = "coolreader";
  version = "3.2.53";

  src = fetchFromGitHub {
    owner = "buggins";
    repo = pname;
    rev = "cr${version}";
    sha256 = "sha256-5it70cwRV56OMZI4dny5uwxWgoF42tjcEC4g3MC548s=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ qttools fribidi libunibreak ];

  meta = with lib; {
    homepage = "https://github.com/buggins/coolreader";
    description = "Cross platform open source e-book reader";
    license = licenses.gpl2Plus; # see https://github.com/buggins/coolreader/issues/80
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
