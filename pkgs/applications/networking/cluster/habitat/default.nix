{ lib, fetchFromGitHub, rustPlatform, pkg-config
, libsodium, libarchive, openssl, zeromq }:

rustPlatform.buildRustPackage rec {
  pname = "habitat";
  # Newer versions required protobuf, which requires some finesse to get to
  # compile with the vendored protobuf crate.
  version = "0.90.6";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    sha256 = "0rwi0lkmhlq4i8fba3s9nd9ajhz2dqxzkgfp5i8y0rvbfmhmfd6b";
  };

  cargoSha256 = "1c058sjgd79ps8ahvxp25qyc3a6b2csb41vamrphv9ygai60mng6";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsodium libarchive openssl zeromq ];

  cargoBuildFlags = ["--package hab"];

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    cargo test --package hab
    runHook postCheck
  '';

  meta = with lib; {
    description = "An application automation framework";
    homepage = "https://www.habitat.sh";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem ];
    platforms = [ "x86_64-linux" ];
  };
}
