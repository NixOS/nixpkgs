{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "capnproto-rust";
  version = "0.25.3";

  src = fetchCrate {
    crateName = "capnpc";
    inherit (finalAttrs) version;
    hash = "sha256-jDdsGy/T41R4duclyMpPmPZeflXg+Zp7wdBxbR527ZM=";
  };

  cargoHash = "sha256-egb4Jpwzkj3PSVStqCX5ZLKgrH7nGHgZUCIleZcWIeI=";

  postInstall = ''
    mkdir -p $out/include/capnp
    cp rust.capnp $out/include/capnp
  '';

  nativeCheckInputs = [
    capnproto
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cap'n Proto codegen plugin for Rust";
    homepage = "https://github.com/capnproto/capnproto-rust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mikroskeem
      solson
    ];
  };
})
