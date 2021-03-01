{ lib, stdenv, mkDerivation, fetchFromGitHub, qmake, pkg-config, qttools, qtwebengine, hunspell }:

mkDerivation rec {
  pname = "ghostwriter";
  version = "2.0.0-rc4";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = version;
    sha256 = "07547503a209hc0fcg902w3x0s1m899c10nj3gqz3hak0cmrasi3";
  };

  nativeBuildInputs = [ qmake pkg-config qttools ];

  buildInputs = [ qtwebengine hunspell ];

  meta = with lib; {
    description = "A cross-platform, aesthetic, distraction-free Markdown editor";
    homepage = src.meta.homepage;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda erictapen ];
    broken = stdenv.isDarwin;
  };
}
