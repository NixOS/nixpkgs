{ asciidoctor
, darwin
, fetchgit
, git
, installShellFiles
, jq
, lib
, makeWrapper
, man-db
, openssh
, radicle-node
, runCommand
, rustPlatform
, stdenv
, testers
, xdg-utils
}: rustPlatform.buildRustPackage rec {
  pname = "radicle-node";
  version = "1.0.0-rc.10";
  env.RADICLE_VERSION = version;

  src = fetchgit {
    url = "https://seed.radicle.xyz/z3gqcJUoA1n9HaHKufZs5FCSGazv5.git";
    rev = "refs/namespaces/z6MksFqXN3Yhqk8pTJdUGLwATkRfQvwZXPqR2qMEhbS9wzpT/refs/tags/v${version}";
    hash = "sha256-bkP9/S9luT0tgESabt3KaaEUObx6SGxz87XLOIIrDNw=";
  };
  cargoHash = "sha256-FDxXFhQmpWwkvAMawBTwuSXOz1UMqP83Csk9N0atlN8=";

  nativeBuildInputs = [ asciidoctor installShellFiles makeWrapper ];
  nativeCheckInputs = [ git ];
  buildInputs = lib.optionals stdenv.buildPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  doCheck = stdenv.hostPlatform.isLinux;

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release
    # Tests want to open many files.
    ulimit -n 4096
  '';
  checkFlags = [
    "--skip=service::message::tests::test_node_announcement_validate"
    "--skip=tests::test_announcement_relay"
    # https://radicle.zulipchat.com/#narrow/stream/369277-heartwood/topic/Flaky.20tests/near/438352360
    "--skip=tests::e2e::test_connection_crossing"
  ];

  postInstall = ''
    for page in $(find -name '*.adoc'); do
      asciidoctor -d manpage -b manpage $page
      installManPage ''${page::-5}
    done
  '';

  postFixup = ''
    for program in $out/bin/* ;
    do
      wrapProgram "$program" \
        --prefix PATH : "${lib.makeBinPath [ git man-db openssh xdg-utils ]}"
    done
  '';

  passthru.tests =
    let
      package = radicle-node;
    in
    {
      version = testers.testVersion { inherit package; };
      basic = runCommand "${package.name}-basic-test"
        {
          nativeBuildInputs = [ jq openssh radicle-node ];
        } ''
        set -e
        export RAD_HOME="$PWD/.radicle"
        mkdir -p "$RAD_HOME/keys"
        ssh-keygen -t ed25519 -N "" -f "$RAD_HOME/keys/radicle" > /dev/null
        jq -n '.node.alias |= "nix"' > "$RAD_HOME/config.json"

        rad config > /dev/null
        rad debug | jq -e '
            (.sshVersion | contains("${openssh.version}"))
          and
            (.gitVersion | contains("${git.version}"))
        '

        touch $out
      '';
    };

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
