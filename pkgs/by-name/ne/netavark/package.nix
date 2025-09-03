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
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${version}";
    hash = "sha256-8Yai0c5AHHx+xTEVH23C5dy4VXRERLeg0iIAbD/Glis=";
  };

  cargoHash = "sha256-U8rNA5sAR9+q7cWQBt18iJfnylcCq/tVLXAdxWpAhjw=";

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
