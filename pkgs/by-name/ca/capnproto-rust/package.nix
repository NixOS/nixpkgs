{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "capnproto-rust";
  version = "0.28.1";

  src = fetchCrate {
    crateName = "capnpc";
    inherit (finalAttrs) version;
    hash = "sha256-ODqjoipyacdrI/4HiHUEskjpbV/HiiMVq/Kf6GbANdo=";
  };

  cargoHash = "sha256-fzCwQL9M/jQe5nm4488w+4RyOA7575xQ5mEgvlufQKI=";

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
