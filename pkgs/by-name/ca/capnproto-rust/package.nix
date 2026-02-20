{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "capnproto-rust";
  version = "0.25.0";

  src = fetchCrate {
    crateName = "capnpc";
    inherit (finalAttrs) version;
    hash = "sha256-2+GSM9oIT/he/Ra3SJH5YSrNUU/Jc+PE1N5TjK7OX28=";
  };

  cargoHash = "sha256-fVHLWBxB9PQhOx01G01qIyudnMQiHXj0BI8A6e7t1yQ=";

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
