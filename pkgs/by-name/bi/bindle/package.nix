{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "bindle";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "deislabs";
    repo = "bindle";
    rev = "v${version}";
    sha256 = "sha256-xehn74fqP0tEtP4Qy9TRGv+P2QoHZLxRHzGoY5cQuv0=";
  };

  postPatch = ''
    rm .cargo/config
  '';

  doCheck = false; # Tests require a network

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  cargoHash = "sha256-cTgR1yp6TFwotm5VEG5e0O7R1zCMbQmcH2zmRmF7cjI=";

  cargoBuildFlags = [
    "--bin"
    "bindle"
    "--bin"
    "bindle-server"
    "--all-features"
  ];

  meta = with lib; {
    description = "Object Storage for Collections";
    homepage = "https://github.com/deislabs/bindle";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
