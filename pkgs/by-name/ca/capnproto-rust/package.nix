{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "capnproto-rust";
  version = "0.26.0";

  src = fetchCrate {
    crateName = "capnpc";
    inherit (finalAttrs) version;
    hash = "sha256-zMaOGwbCnczEY9V2xh3pXuDPYtr91sRblDwSjH/2f0s=";
  };

  cargoHash = "sha256-PgMj+sEvvkkySkL25sgfKzZiKYQX+U0Pt8gJOkZwRzA=";

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
