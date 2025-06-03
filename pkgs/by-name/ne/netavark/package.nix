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
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${version}";
    hash = "sha256-V+JwfKWo8gqVq/lF0MMt8sovPRyb3saBxsUhdMo4C5g=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-C2+N3jPdqh/cmJ2efrUnScXo1rFBEec6w4r8M6OfcPo=";

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
