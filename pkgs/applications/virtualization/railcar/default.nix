{ stdenv, lib, fetchFromGitHub, fetchpatch, rustPlatform, libseccomp }:

rustPlatform.buildRustPackage rec {
  name = "railcar-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "railcar";
    rev = "v${version}";
    sha256 = "09zn160qxd7760ii6rs5nhr00qmaz49x1plclscznxh9hinyjyh9";
  };

  cargoSha256 = "16f3ys0zzha8l5jdklmrqivl8hmrb9qgqgzcm3jn06v45hls9lan";

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
