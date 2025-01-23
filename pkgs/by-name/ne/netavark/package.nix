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
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Vz2/Y8o6fiVdLElgytUqLfa1oK/kyu1+dks4aiDHMAY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OrqhGTHd6gi6nMqvM/znQSwNoN5VSBRzcdgY3LbpYWU=";

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
