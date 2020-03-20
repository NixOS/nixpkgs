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

  # Submitted upstream https://github.com/oracle/railcar/pull/44
  cargoPatches = [ ./cargo-lock.patch ];
  cargoSha256 = "10qxkxpdprl2rcgy52s3q5gyg3i75qmx68rpl7cx1bgjzppfn9c3";

  buildInputs = [ libseccomp ];

  meta = with lib; {
    description = "Rust implementation of the Open Containers Initiative oci-runtime";
    homepage = https://github.com/oracle/railcar;
    license = with licenses; [ asl20 /* or */ upl ];
    maintainers = [ maintainers.spacekookie ];
    platforms = platforms.all;
  };
}
