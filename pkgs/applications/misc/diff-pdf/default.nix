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
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "diff-pdf";
    rev = "v${version}";
    sha256 = "1y5ji4c4m69vzs0z051fkhfdrjnyxb6kzac5flhdkfb2hgp1jnxl";
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
