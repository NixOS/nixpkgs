{ lib, stdenv, fetchFromGitHub, autoconf, automake, pkg-config, cairo, poppler, wxGTK ? null, wxmac ? null, darwin ? null }:

let
  wxInputs =
    if stdenv.isDarwin then
      [ wxmac darwin.apple_sdk.frameworks.Cocoa ]
    else
      [ wxGTK ];
in
stdenv.mkDerivation rec {
  pname = "diff-pdf";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "diff-pdf";
    rev = "v${version}";
    sha256 = "sha256-Si8v5ZY1Q/AwQTaxa1bYG8bgqxWj++c4Hh1LzXSmSwE=";
  };

  nativeBuildInputs = [ autoconf automake pkg-config ];
  buildInputs = [ cairo poppler ] ++ wxInputs;

  preConfigure = "./bootstrap";

  meta = with lib; {
    homepage = "https://vslavik.github.io/diff-pdf/";
    description = "Simple tool for visually comparing two PDF files";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ dtzWill ];
  };
}
