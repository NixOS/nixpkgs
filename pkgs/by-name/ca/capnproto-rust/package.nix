{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
<<<<<<< HEAD
  version = "0.24.0";
=======
  version = "0.23.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-kR+eGH+AnZbnPp4+WJ/hgccO3T4xevrCaF8KL+8zWr0=";
  };

  cargoHash = "sha256-viLoCQSAGS7Y/FFUsPpW/XaqVNbGtzC2v2ji39GrrBk=";
=======
    hash = "sha256-dmLR1jMH90axlylkA3m48FK367c67o4CgIc+M6gKz0o=";
  };

  cargoHash = "sha256-g3/SpeqVtNCu35jj7apAg64/R5R/m1Z2jbKMARph7jo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postInstall = ''
    mkdir -p $out/include/capnp
    cp rust.capnp $out/include/capnp
  '';

  nativeCheckInputs = [
    capnproto
  ];

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    description = "Cap'n Proto codegen plugin for Rust";
    homepage = "https://github.com/capnproto/capnproto-rust";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Cap'n Proto codegen plugin for Rust";
    homepage = "https://github.com/capnproto/capnproto-rust";
    license = licenses.mit;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mikroskeem
      solson
    ];
  };
}
