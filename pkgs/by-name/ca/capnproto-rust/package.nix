{
  lib,
  fetchCrate,
  rustPlatform,
  capnproto,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "capnproto-rust";
  version = "0.21.1";

  src = fetchCrate {
    crateName = "capnpc";
    inherit version;
    hash = "sha256-WqzcUnAx/qD50/ZlWlWS4bguTxW+qFj0uFzwsbxHBaw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-FtJvm6uUFSHn8lQxEFoWpSZgqomfHYkR3E0kKsV/II4=";

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
