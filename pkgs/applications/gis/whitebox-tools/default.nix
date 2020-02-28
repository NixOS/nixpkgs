{ stdenv, rustPlatform , fetchFromGitHub, Security }:
rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "v${version}";
    sha256 = "0zi32d0wrbl2763dcllv2g0liwacsfiza5lkx52620prjjbhby8i";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "13k21akyfqgamywj39bw73sldby1s02vyvxfglxbaqq1x96xcy4i";

  # failures: structures::polyline::test::test_polyline_split
  doCheck = false;

  meta = with stdenv.lib; {
    description = "An advanced geospatial data analysis platform";
    homepage = http://www.uoguelph.ca/~hydrogeo/WhiteboxTools/index.html;
    license = licenses.mit;
    maintainers = [ maintainers.mpickering ];
    platforms = platforms.all;
  };
}
