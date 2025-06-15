{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "live-server";
  version = "0.10.0-unstable-2025-06-15";

  src = fetchFromGitHub {
    owner = "lomirus";
    repo = "live-server";
    rev = "8cadd4bd40568c1bb8006f3a12c5cd269071c147";
    hash = "sha256-BlVQKsf5wfqiqMv2fHMYaHm8a+CjbkcNvD6YgZbxd7k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-lW6sZHbroqMtt/JANXD+McFt4DXtlFXEZ9sDuXV25ns=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Local network server with live reload feature for static pages";
    downloadPage = "https://github.com/lomirus/live-server/releases";
    homepage = "https://github.com/lomirus/live-server";
    license = licenses.mit;
    mainProgram = "live-server";
    maintainers = [ maintainers.philiptaron ];
    platforms = platforms.unix;
  };
}
