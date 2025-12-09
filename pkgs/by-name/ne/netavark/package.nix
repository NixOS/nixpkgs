{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  mandown,
  protobuf,
  nixosTests,
  go-md2man,
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${version}";
    hash = "sha256-Co7Wt6eUwbDVd+MljXh+kJ1Op8ekGzYxWA4j8EWa0jk=";
  };

  cargoHash = "sha256-FBvD7EY+NryetZmJSAMZdikDi5N5kLWHL8gzd0rGnj8=";

  nativeBuildInputs = [
    installShellFiles
    mandown
    protobuf
    go-md2man
  ];

  postBuild = ''
    make -C docs netavark.1
    installManPage docs/netavark.1
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/netavark/releases/tag/${src.rev}";
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    teams = [ teams.podman ];
    platforms = platforms.linux;
  };
}
