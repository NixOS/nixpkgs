{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:
rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = version;
    sha256 = "0s5byn8qyi1bm59j9vhwqaygw5cxipc7wbd3flh7n24nx0s8pr8c";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoSha256 = "0rdg9k44si37iyqlcl1rw7ilajcvqy93gbfpd7n4cr1hg9ypm0m3";

  meta = with lib; {
    description = "An advanced geospatial data analysis platform";
    homepage = "https://jblindsay.github.io/ghrg/WhiteboxTools/index.html";
    license = licenses.mit;
    maintainers = [ maintainers.mpickering ];
  };
}
