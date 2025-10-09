{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  capnproto,
}:

rustPlatform.buildRustPackage rec {
  pname = "flowgger";
  version = "0.3.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eybahv1A/AIpAXGj6/md8k+b9fu9gSchU16fnAWZP2s=";
  };

  cargoHash = "sha256-50/rg1Bo8wEpD9UT1EWIKNLglZLS1FigoPtZudDaL4c=";

  nativeBuildInputs = [
    pkg-config
    capnproto
  ];

  buildInputs = [ openssl ];

  checkFlags = [
    # test failed
    "--skip=flowgger::encoder::ltsv_encoder::test_ltsv_full_encode_multiple_sd"
    "--skip=flowgger::encoder::ltsv_encoder::test_ltsv_full_encode_no_sd"
  ];

  meta = with lib; {
    homepage = "https://github.com/awslabs/flowgger";
    description = "Fast, simple and lightweight data collector written in Rust";
    license = licenses.bsd2;
    maintainers = [ ];
    mainProgram = "flowgger";
  };
}
