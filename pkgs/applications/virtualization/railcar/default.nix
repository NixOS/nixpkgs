{ lib, fetchFromGitHub, rustPlatform, libseccomp }:

rustPlatform.buildRustPackage rec {
  pname = "railcar";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "railcar";
    rev = "v${version}";
    sha256 = "09zn160qxd7760ii6rs5nhr00qmaz49x1plclscznxh9hinyjyh9";
  };

  # Delete this on next update; see #79975 for details
  legacyCargoFetcher = true;

  cargoSha256 = "1k4y37x783fsd8li17k56vlx5ziwmrz167a0w5mcb9sgyd2kc19a";

  buildInputs = [ libseccomp ];

  # Submitted upstream https://github.com/oracle/railcar/pull/44
  cargoPatches = [ ./cargo-lock.patch ];

  meta = with lib; {
    description = "Rust implementation of the Open Containers Initiative oci-runtime";
    homepage = https://github.com/oracle/railcar;
    license = with licenses; [ asl20 /* or */ upl ];
    maintainers = [ maintainers.spacekookie ];
    platforms = platforms.all;
  };
}
