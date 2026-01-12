{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.24.0";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-kR+eGH+AnZbnPp4+WJ/hgccO3T4xevrCaF8KL+8zWr0=";
  };

  cargoHash = "sha256-viLoCQSAGS7Y/FFUsPpW/XaqVNbGtzC2v2ji39GrrBk=";

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
}
