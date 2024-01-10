{ lib, stdenv, mkDerivation, fetchFromGitHub, pkg-config, qmake, qtx11extras, qttools, mpv }:

mkDerivation rec {
  pname = "mpc-qt";
  version = "23.02";

  src = fetchFromGitHub {
    owner = "mpc-qt";
    repo = "mpc-qt";
    rev = "v${version}";
    sha256 = "sha256-b8efsdWWpwoaiX+oQhHK15KxD6JpvPhESTxCR2kS7Mk=";
  };

  nativeBuildInputs = [ pkg-config qmake qttools ];

  buildInputs = [ mpv qtx11extras ];

  qmakeFlags = [ "QMAKE_LUPDATE=${qttools.dev}/bin/lupdate" ];

  meta = with lib; {
    description = "Media Player Classic Qute Theater";
    homepage = "https://mpc-qt.github.io";
    license = licenses.gpl2;
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ romildo ];
    mainProgram = "mpc-qt";
  };
}
