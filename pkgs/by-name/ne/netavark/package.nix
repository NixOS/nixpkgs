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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "netavark";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hMtYAG1OnnK1xECp8yiGEtgrWWnVfywLokOw6fzKEjw=";
  };

  cargoHash = "sha256-oVIOS0bzvT6FW43TJ/p0PZO/cjskzljhyxqeM0aSCCo=";

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

  meta = {
    changelog = "https://github.com/containers/netavark/releases/tag/${finalAttrs.src.rev}";
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = lib.licenses.asl20;
    teams = [ lib.teams.podman ];
    platforms = lib.platforms.linux;
  };
})
