{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, libgit2
, openssl
, pkg-config
, makeWrapper
, git
, darwin
}:

let
  # josh-ui requires javascript dependencies, haven't tried to figure it out yet
  cargoFlags = [ "--workspace" "--exclude" "josh-ui" ];
  version = "24.08.14";
in

rustPlatform.buildRustPackage {
  pname = "josh";
  inherit version;

  src = fetchFromGitHub {
    owner = "esrlabs";
    repo = "josh";
    rev = "v${version}";
    hash = "sha256-6U1nhERpPQAVgQm6xwRlHIhslYBLd65DomuGn5yRiSs=";
  };

  cargoHash = "sha256-s6+Bd4ucwUinrcbjNvlDsf9LhWc/U9SAvBRW7JAmxVA=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libgit2
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.Security
  ];

  cargoBuildFlags = cargoFlags;
  cargoTestFlags = cargoFlags;

  # used to teach josh itself about its version number
  env.JOSH_VERSION = "r${version}";

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
