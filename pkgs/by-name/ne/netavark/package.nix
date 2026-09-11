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
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "netavark";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FdJNcHYK6Jc1dNqcUr5Ne8dv1dzlHRhcjoldiihrov8=";
  };

  cargoHash = "sha256-wp/1lWc3OfNQt74m8DtpuFO/Mf07+M7numq2FMEkeGo=";

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
