{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.21.0";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-QI38Xy0zgL+sgH1WaOL2eMcQdOPPHE9Dcucs42eaL2o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Oljyv9qCfZF2/CoHNqs9bvCAEfGpmfvNzTvvyaVMH2U=";

  postInstall = ''
    mkdir -p $out/include/capnp
    cp rust.capnp $out/include/capnp
  '';

  nativeCheckInputs = [
    capnproto
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Cap'n Proto codegen plugin for Rust";
    homepage = "https://github.com/capnproto/capnproto-rust";
    license = licenses.mit;
    maintainers = with maintainers; [
      mikroskeem
      solson
    ];
  };
}
