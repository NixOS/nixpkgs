{ lib, stdenv, fetchFromGitHub, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "mhost";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "lukaspustina";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j0378f8gj8hdcdhpj6lqlnriasmjxzri42wjj9pygzkmpd3ym86";
  };

  cargoSha256 = "0gqrya0bpdd67k2sxib7f4npnrx84d9r4hjq2sg2xz4j8pmgs018";

  buildInputs = lib.optional stdenv.isDarwin Security;

  CARGO_CRATE_NAME = "mhost";

  doCheck = false;

  meta = with lib; {
    description = "A modern take on the classic host DNS lookup utility including an easy to use and very fast Rust lookup library";
    homepage = "https://github.com/lukaspustina/mhost";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = [ maintainers.mgttlinger ];
    mainProgram = "mhost";
  };
}
