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
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${version}";
    hash = "sha256-8PU6CNgpxsTwqLdLHF5cPwAe/9jUMwOBCIWeFoatXEA=";
  };

  cargoHash = "sha256-jLA0KfM/lnXrZW5yfjDBBdIb7cE3pq9puV7NDZv43SY=";

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
