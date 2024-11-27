{ lib
, fetchCrate
, rustPlatform
, capnproto
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.17.2";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-WVjXVLVoTCAtA8a6+zaX4itAaPCWb2c0trtSsxBopO4=";
  };

  cargoHash = "sha256-h9YArxHnY14T8eQCS4JVItjaCjv+2dorcOVBir7r6SY=";

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
    maintainers = with maintainers; [ mikroskeem solson ];
  };
}
