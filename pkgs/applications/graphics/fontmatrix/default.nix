{ lib, mkDerivation, fetchpatch, fetchFromGitHub, cmake, qttools, qtwebkit }:

mkDerivation rec {
  pname = "fontmatrix";
  version = "0.6.0-qt5";

  src = fetchFromGitHub {
    owner = "fcoiffie";
    repo = "fontmatrix";
    rev = "1ff8382d8c85c18d9962918f461341ff4fe21993";
    sha256 = "0yx1gbsjj9ddq1kiqplif1w5x5saw250zbmhmd4phqmaqzr60w0h";
  };

  # Add missing QAction include
  patches = [ (fetchpatch {
    url = "https://github.com/fcoiffie/fontmatrix/commit/dc6de8c414ae21516b72daead79c8db88309b102.patch";
    sha256 = "092860fdyf5gq67jqfxnlgwzjgpizi6j0njjv3m62aiznrhig7c8";
  })];

  buildInputs = [ qttools qtwebkit ];

  nativeBuildInputs = [ cmake ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "Fontmatrix is a free/libre font explorer for Linux, Windows and Mac";
    homepage = "https://github.com/fontmatrix/fontmatrix";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
