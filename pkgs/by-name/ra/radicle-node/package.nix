{ lib
, stdenv
, fetchgit
, asciidoctor
, git
, installShellFiles
, rustPlatform
, testers
, radicle-node
, darwin
}: rustPlatform.buildRustPackage rec {
  pname = "radicle-node";
  version = "1.0.0-rc.8";
  env.RADICLE_VERSION = version;

  src = fetchgit {
    url = "https://seed.radicle.xyz/z3gqcJUoA1n9HaHKufZs5FCSGazv5.git";
    rev = "refs/namespaces/z6MksFqXN3Yhqk8pTJdUGLwATkRfQvwZXPqR2qMEhbS9wzpT/refs/tags/v${version}";
    hash = "sha256-F2n7ui0EgXK8fT76M14RVhXXGeRYub+VpH+puDUJ1pQ=";
  };
  cargoHash = "sha256-+QthR5M3qAxC42TPnR5iylfpuWnsSmg68SuCbhmkCvw=";

  nativeBuildInputs = [ asciidoctor installShellFiles ];
  nativeCheckInputs = [ git ];
  buildInputs = lib.optionals stdenv.buildPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  doCheck = with stdenv.hostPlatform; isx86_64 && isLinux;

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release
  '';
  checkFlags = [
    "--skip=service::message::tests::test_node_announcement_validate"
    "--skip=tests::test_announcement_relay"
    "--skip=tests::e2e"
  ];

  postInstall = ''
    for page in $(find -name '*.adoc'); do
      asciidoctor -d manpage -b manpage $page
      installManPage ''${page::-5}
    done
  '';

  passthru.tests.version = testers.testVersion { package = radicle-node; };

  meta = {
    description = "Radicle node and CLI for decentralized code collaboration";
    longDescription = ''
      Radicle is an open source, peer-to-peer code collaboration stack built on Git.
      Unlike centralized code hosting platforms, there is no single entity controlling the network.
      Repositories are replicated across peers in a decentralized manner, and users are in full control of their data and workflow.
    '';
    homepage = "https://radicle.xyz";
    license = with lib.licenses; [ asl20 mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ amesgen lorenzleutgeb ];
    mainProgram = "rad";
  };
}
