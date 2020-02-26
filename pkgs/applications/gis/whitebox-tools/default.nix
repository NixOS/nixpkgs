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

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "0zn4b4md3pn1rvb15rnz3zcx9a359x26nfy7zcfp7nx27ais13n5";

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
