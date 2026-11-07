{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-web-server";
  version = "18.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bohdaq";
    repo = "rust-web-server";
    tag = finalAttrs.version;
    hash = "sha256-noA30MFzTgG984Rdf9uIC4P1LuD5wa4blvJu7Vcciys=";
  };

  cargoHash = "sha256-2q1g+fJqnXVTF2PzZrUlaB2WH+x2bzLXd4bkvy+x1qA=";

  # aws-lc-sys (TLS) builds with cmake and perl.
  nativeBuildInputs = [
    cmake
    perl
  ];

  cargoBuildFlags = [
    "--bin"
    "rws"
  ];
  buildFeatures = [
    "acme"
    "auth"
  ];

  # The library's unit tests; the rest bind sockets or need the network.
  cargoTestFlags = [ "--lib" ];

  meta = {
    description = "Web server and reverse proxy with automatic HTTPS, HTTP/3, load balancing and auth";
    homepage = "https://rws8.tech";
    changelog = "https://github.com/bohdaq/rust-web-server/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "rws";
    maintainers = with lib.maintainers; [ bohdaq ];
  };
})
