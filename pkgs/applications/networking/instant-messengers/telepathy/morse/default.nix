{ stdenv, fetchFromGitHub, cmake, qtbase, telepathy, telegram }:

stdenv.mkDerivation rec {
  name = "telepathy-morse-unstable-${version}";
  version = "2017-04-14";

  src = fetchFromGitHub {
    owner = "TelepathyIM";
    repo = "telepathy-morse";
    rev = "bf8b134556a20d2d7f1ace03f1f45e2a63bacb6f";
    sha256 = "07j77il0jim7p2azgpj9vxjhll9qq83c9r0rbkfh0gg9zydp1s51";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase telepathy telegram ];

  meta = with stdenv.lib; {
    description = "Telepathy Connection Manager for the Telegram network";
    homepage = src.meta.homepage;
    license = licenses.gpl2;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
