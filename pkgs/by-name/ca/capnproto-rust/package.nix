{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.21.2";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-9Vsr6pRfC8Onqw/Yna2cJl1L70uo3K/C80CztNw0XoQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-V92zF75fd5MVz84YnWJONNjxZsA4zHTee1hAPAkoX6k=";

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
