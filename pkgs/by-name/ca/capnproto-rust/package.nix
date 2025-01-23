{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.17.2";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-WVjXVLVoTCAtA8a6+zaX4itAaPCWb2c0trtSsxBopO4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-iV83AbXzxNZ78V8yLSfF9PebDGEw+9sbTP41krd7ujI=";

  postInstall = ''
    mkdir -p $out/include/capnp
    cp rust.capnp $out/include/capnp
  '';

  nativeCheckInputs = [
    capnproto
  ];

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
