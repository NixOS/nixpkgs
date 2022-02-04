{ lib, stdenv, rustPlatform, fetchFromGitHub, Security }:
rustPlatform.buildRustPackage rec {
  pname = "whitebox_tools";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "7551aa70e8d9cbd8b3744fde48e82aa40393ebf8";
    sha256 = "0mngw99aj60bf02y3piimxc1z1zbw1dhwyixndxh3b3m9xqhk51h";
  };

  cargoPatches = [./update-cargo-lock.patch];

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoSha256 = "08xif13vqhy71w7fnxdyxsd9hvkr22c6kffh521sr0l8z6zlp0gq";

  doCheck = false;

  meta = with lib; {
    description = "An advanced geospatial data analysis platform";
    homepage = "https://jblindsay.github.io/ghrg/WhiteboxTools/index.html";
    license = licenses.mit;
    maintainers = [ maintainers.mpickering ];
  };
}
