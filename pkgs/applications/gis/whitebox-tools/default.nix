{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "7551aa70e8d9cbd8b3744fde48e82aa40393ebf8";
    hash = "sha256-MJQJcU91rAF7sz16Dlvg64cfWK8x3uEFcAsYqVLiz1Y=";
  };

  cargoSha256 = "sha256-+IFLv/mIgqyDKNC5aZgQeW6Ymu6+desOD8dDvEdwsSM=";

  cargoPatches = [
    ./update-cargo-lock.patch
  ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  doCheck = false;

  meta = with lib; {
    homepage = "https://jblindsay.github.io/ghrg/WhiteboxTools/index.html";
    description = "An advanced geospatial data analysis platform";
    license = licenses.mit;
    maintainers = [ maintainers.mpickering ];
  };
}
