{ stdenv, rustPlatform , fetchFromGitHub, Security }:
rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "v${version}";
    sha256 = "1vs4hf2x3qjnffs9kjx56rzl67kpcy8xvng6p0r9fp9mfnblxg6j";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "1y3vk8bzsaisx7wrncjxcqdh355f2wk4n59vq5qgj37fph2zpy7f";

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
