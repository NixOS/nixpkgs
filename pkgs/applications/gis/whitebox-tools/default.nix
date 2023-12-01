{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "v${version}";
    hash = "sha256-DQ7BPRd90GNQVfD5NoVcxoyd2L3WZvIkecmRJVUY1R4=";
  };

  cargoHash = "sha256-BounjGGhbU5dxNV8WjVDQtV7YONNVRldc/t+wet1Gh8=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    homepage = "https://jblindsay.github.io/ghrg/WhiteboxTools/index.html";
    description = "An advanced geospatial data analysis platform";
    license = licenses.mit;
    maintainers = [ maintainers.mpickering ];
  };
}
