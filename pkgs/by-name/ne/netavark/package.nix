{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
, protobuf
, nixosTests
, go-md2man
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${version}";
    hash = "sha256-kAJOfZ4Q1EQ+JV1izXoLe/Z/qgxbzz3WbczM4fVhxfU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-MdKTGLNf+7SzdkQNLOWgfmSE9TNLYzPFU0oXh6MnW5w=";

  nativeBuildInputs = [ installShellFiles mandown protobuf go-md2man ];

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
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
