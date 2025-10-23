{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.21.4";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-pJF0S6mRxPjpwa367eOUgc7GBeKgUwux1GgUIJE8JuI=";
  };

  cargoHash = "sha256-nPDfBpY7WtNr1St6HAymWBLho5n0UXibqDjVA1vXeNg=";

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
