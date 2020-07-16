{ stdenv, rustPlatform , fetchFromGitHub, Security }:
rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "v${version}";
    sha256 = "0c9jmfjz6ys65y65zlllv9xvaaavr9jpqc1dc217iywhj07j8k2v";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "05w2jimmygg7dc93i8bpjpjc5yj5xfpfkjnbbgw2sq4kh06r5ii4";

  meta = with stdenv.lib; {
    description = "An advanced geospatial data analysis platform";
    homepage = "https://jblindsay.github.io/ghrg/WhiteboxTools/index.html";
    license = licenses.mit;
    maintainers = [ maintainers.mpickering ];
    platforms = platforms.all;
  };
}
