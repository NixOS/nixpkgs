{ stdenv, fetchFromGitHub, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "fontmatrix-${version}";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fontmatrix";
    repo = "fontmatrix";
    rev = "v${version}";
    sha256 = "0aqndj1jhm6hjpwmj1qm92z2ljh7w78a5ff5ag47qywqha1ngn05";
  };

  buildInputs = [ qt4 ];

  nativeBuildInputs = [ cmake ];

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Fontmatrix is a free/libre font explorer for Linux, Windows and Mac";
    homepage = https://github.com/fontmatrix/fontmatrix;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
