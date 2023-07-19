{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, installShellFiles
, asciidoctor
, DarwinTools
, AppKit
, git
, testers
, radicle-cli
, tree
}:

rustPlatform.buildRustPackage rec {
  pname = "radicle-cli";
  version = "0.8.0-unstable-2023-10-11";

  src = fetchFromGitHub {
    owner = "radicle-dev";
    repo = "heartwood";
    rev = "c3e11057ad933aeef27ffe091be2048557cad469";
    hash = "sha256-ZuNtxy5k2TBDjn/aQckRvk5JmK4eUF6bFCzf2PgnFUs=";
  };

  patches = [
    ./disable-failing-tests.patch
  ];
  cargoHash = "sha256-Sq9aIaUZBXPXqYLwSIJyrNtLDWS5C1Uyc28ax3YZCAE=";

  nativeBuildInputs = [ asciidoctor installShellFiles ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    DarwinTools
  ];

  buildInputs = [ ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    AppKit
  ];

  checkType = "debug";
  nativeCheckInputs = [ git tree ];

  # Targets built: rad radicle-node git-remote-rad
  # This cargoBuildFlag ensures more binaries are generated, e.g.
  # rad-agent, rad-cli-demo, radicle-httpd, radicle-tui, rad-init, rad-push, rad-self, rad-set-canonical-refs
  cargoBuildFlags = ["--workspace"];

  # Check if the binary reports the same version:
  passthru.tests = {
    version = testers.testVersion {
      package = radicle-cli;
      version = lib.head (lib.splitString "-" version);
    };
  };

  postInstall = ''
    for f in $(find . -name '*.adoc'); do
      mf=''${f%.*}
      asciidoctor --doctype manpage --backend manpage $f -o $mf
      installManPage $mf
    done
  '';

  meta = {
    description = "Command-line tooling for Radicle, a decentralized code collaboration network";
    homepage = "https://radicle.xyz";
    license = [ lib.licenses.mit lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ amesgen luz ];
    platforms = lib.platforms.unix;
    mainProgram = "rad";
  };
}
