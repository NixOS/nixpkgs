{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.20.1";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-iLjvKxVfkAVoM4AYgr31Ud1mk3MyMPReDXv1IbKEvcE=";
  };

  cargoHash = "sha256-KNUXIKzTlbEW7WUwqVOXjN5/6BDGEbOjbKELo0KtWDc=";

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
