{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "capnproto-rust";
  version = "0.27.0";

  src = fetchCrate {
    crateName = "capnpc";
    inherit (finalAttrs) version;
    hash = "sha256-lFMezKqz29LvujoC18OPOYKzvPVZHYXmFLVFyveQ5P0=";
  };

  cargoHash = "sha256-BuuH+7JB8shgDltpUlSNZUwvScErmezrYMLRyHF9swY=";

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
