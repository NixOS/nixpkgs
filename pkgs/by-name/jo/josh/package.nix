{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libgit2,
  openssl,
  pkg-config,
  makeWrapper,
  git,
}:

let
  version = "26.05.08";
in

rustPlatform.buildRustPackage {
  pname = "josh";
  inherit version;

  src = fetchFromGitHub {
    owner = "josh-project";
    repo = "josh";
    rev = "r${version}";
    hash = "sha256-rG5ZkEH8ZL8t0sDnBnNPtVtaR1I8BoulXlFh0HCpMsw=";
  };

  cargoHash = "sha256-/hMn80jHDF9gh+K8IOV5zXllzJkCdcmvI/NmbKFd/uM=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libgit2
    openssl
  ];

  cargoBuildFlags = [ "--workspace" ];
  # josh-proxy's inline tests need to interact with a specific test environment
  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "josh-proxy"
  ];

  # used to teach josh itself about its version number
  env.JOSH_VERSION = "r${version}";

  # josh and josh-filter are used interactively, so git is likely already in PATH
  postInstall = ''
    wrapProgram "$out/bin/josh-proxy" --prefix PATH : "${git}/bin"
  '';

  meta = {
    description = "Just One Single History";
    homepage = "https://josh-project.github.io/josh/";
    downloadPage = "https://github.com/josh-project/josh";
    changelog = "https://github.com/josh-project/josh/releases/tag/r${version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sternenseemann
      lib.maintainers.tazjin
    ];
    platforms = lib.platforms.all;
  };
}
