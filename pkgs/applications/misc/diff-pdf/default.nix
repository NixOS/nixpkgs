{ lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, cairo, poppler, wxGTK, Cocoa }:

stdenv.mkDerivation rec {
  pname = "diff-pdf";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "diff-pdf";
    rev = "v${version}";
    sha256 = "sha256-6aKF3Xqp/1BoHEiZVZJSemTjn5Qwwr3QyhsXOIjTr08=";
  };

  nativeBuildInputs = [ autoconf automake pkg-config ];
  buildInputs = [ cairo poppler wxGTK ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Cocoa ];

  preConfigure = "./bootstrap";

  meta = with lib; {
    homepage = "https://vslavik.github.io/diff-pdf/";
    description = "Simple tool for visually comparing two PDF files";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "diff-pdf";
  };
}
