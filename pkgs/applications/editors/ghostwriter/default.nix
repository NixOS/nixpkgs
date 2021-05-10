{ lib, stdenv, mkDerivation, fetchFromGitHub, qmake, pkg-config, qttools, qtwebengine, hunspell }:

mkDerivation rec {
  pname = "ghostwriter";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "wereturtle";
    repo = pname;
    rev = version;
    sha256 = "sha256-5O2W7ZQeDkNzwi6t9MfNbv4fmNvak1AcMnzJTE1F9L8=";
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
