{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libgit2,
  openssl,
  pkg-config,
  makeWrapper,
  git,
  darwin,
}:

let
  # josh-ui requires javascript dependencies, haven't tried to figure it out yet
  cargoFlags = [
    "--workspace"
    "--exclude"
    "josh-ui"
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "josh";
  version = "23.12.04";
  JOSH_VERSION = "r${version}";

  src = fetchFromGitHub {
    owner = "esrlabs";
    repo = "josh";
    rev = JOSH_VERSION;
    sha256 = "10fspcafqnv6if5c1h8z9pf9140jvvlrch88w62wsg4w2vhaii0v";
  };

  cargoSha256 = "1j0vl3h6f65ldg80bgryh1mz423lcrcdkn8rmajya1850pfxk3w3";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs =
    [
      libgit2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.Security
    ];

  cargoBuildFlags = cargoFlags;
  cargoTestFlags = cargoFlags;

  postInstall = ''
    wrapProgram "$out/bin/josh-proxy" --prefix PATH : "${git}/bin"
  '';

  meta = {
    description = "Just One Single History";
    homepage = "https://josh-project.github.io/josh/";
    downloadPage = "https://github.com/josh-project/josh";
    changelog = "https://github.com/josh-project/josh/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sternenseemann
      lib.maintainers.tazjin
    ];
    platforms = lib.platforms.all;
  };
}
