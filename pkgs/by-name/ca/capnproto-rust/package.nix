{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.23.2";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-dmLR1jMH90axlylkA3m48FK367c67o4CgIc+M6gKz0o=";
  };

  cargoHash = "sha256-g3/SpeqVtNCu35jj7apAg64/R5R/m1Z2jbKMARph7jo=";

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
