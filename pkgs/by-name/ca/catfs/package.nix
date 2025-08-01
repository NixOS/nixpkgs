{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fuse,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "catfs";
  version = "0.9.0-unstable-2023-10-09";

  src = fetchFromGitHub {
    owner = "kahing";
    repo = "catfs";
    rev = "35430f800e68da18fb6bbd25a8f15bf32fa1f166";
    hash = "sha256-hbv4SNe0yqjO6Oomev9uKqG29TiJeI8G7LH+Wxn7hnQ=";
  };

  cargoHash = "sha256-7MrjyIwXiHy6+rrGGpnfKF1+h1dEgUmo+IlwJlDwWbQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fuse ];

  # require fuse module to be active to run tests
  # instead, run command
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/catfs --help > /dev/null
  '';

  meta = with lib; {
    description = "Caching filesystem written in Rust";
    mainProgram = "catfs";
    homepage = "https://github.com/kahing/catfs";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
