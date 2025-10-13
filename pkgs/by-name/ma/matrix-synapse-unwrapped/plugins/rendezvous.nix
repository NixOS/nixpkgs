{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  setuptools-rust,
}:

buildPythonPackage rec {
  pname = "matrix-http-rendezvous-synapse";
  version = "0.1.12";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "rust-http-rendezvous-server";
    rev = "v${version}";
    sha256 = "sha256-minwa+7HLTNSBtBtt5pnoHsFnNEh834nsVw80+FIQi8=";
  };

  postPatch = ''
    cp ${./rendezvous-Cargo.lock} Cargo.lock
  '';

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      postPatch
      ;
    hash = "sha256-CDUyH08s96xUy0VhK+4ym0w9IgAq9P1UjUipVjlpl9c=";
  };

  nativeBuildInputs = [
    setuptools-rust
  ]
  ++ (with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ]);

  buildAndTestSubdir = "synapse";

  pythonImportsCheck = [ "matrix_http_rendezvous_synapse" ];

  meta = with lib; {
    description = "Implementation of MSC3886: Simple rendezvous capability";
    homepage = "https://github.com/matrix-org/rust-http-rendezvous-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
