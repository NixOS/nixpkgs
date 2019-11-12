{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, cairo, poppler, wxGTK ? null, wxmac ? null, darwin ? null }:

let
  wxInputs =
    if stdenv.isDarwin then
      [ wxmac darwin.apple_sdk.frameworks.Cocoa ]
    else
      [ wxGTK ];
in
stdenv.mkDerivation rec {
  pname = "diff-pdf";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "diff-pdf";
    rev = "v${version}";
    sha256 = "0vzvyjpk6m89zs6j1dq85f93n2b1i6akn2g0z9qhagjd2pds920i";
  };

  nativeBuildInputs = [ autoconf automake pkgconfig ];
  buildInputs = [ cairo poppler ] ++ wxInputs;

  preConfigure = "./bootstrap";

  meta = with stdenv.lib; {
    homepage = "https://vslavik.github.io/diff-pdf/";
    description = "Simple tool for visually comparing two PDF files";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
