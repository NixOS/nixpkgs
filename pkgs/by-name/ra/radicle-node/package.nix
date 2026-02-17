{
  asciidoctor,
  fetchFromRadicle,
  gitMinimal,
  installShellFiles,
  jq,
  lib,
  makeBinaryWrapper,
  man-db,
  nixosTests,
  openssh,
  runCommand,
  rustPlatform,
  stdenv,
  xdg-utils,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "radicle-node";
  version = "1.6.1";

  src = fetchFromRadicle {
    seed = "seed.radicle.xyz";
    repo = "z3gqcJUoA1n9HaHKufZs5FCSGazv5";
    tag = "releases/${finalAttrs.version}";
    hash = "sha256-7kwtWuYdYG3MDHThCkY5OZmx4pWaQXMYoOlJszmV2rM=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/.git_head
      git -C $out log -1 --pretty=%ct HEAD > $out/.git_time
      rm -rf $out/.git
    '';
  };

  cargoHash = "sha256-59RyfSUJNoQ7EtQK3OSYOIO/YVEjeeM9ovbojHFX4pI=";

  env.RADICLE_VERSION = finalAttrs.version;

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
    makeBinaryWrapper
  ];
  nativeCheckInputs = [ gitMinimal ];

  preBuild = ''
    export GIT_HEAD=$(<$src/.git_head)
    export SOURCE_DATE_EPOCH=$(<$src/.git_time)
  '';

  cargoBuildFlags = [
    "--package=radicle-node"
    "--package=radicle-cli"
    "--package=radicle-remote-helper"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # tests regularly time out on aarch64
  doCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86;

  preCheck = ''
    export PATH=$PATH:$PWD/target/${stdenv.hostPlatform.rust.rustcTargetSpec}/release
    # Tests want to open many files.
    ulimit -n 4096
    # Cap test threads to avoid timing issues on loaded builders (sync timeout is 5s)
    max_threads=4
    if [[ -n "$NIX_BUILD_CORES" && "$NIX_BUILD_CORES" -lt "$max_threads" ]]; then
      max_threads=$NIX_BUILD_CORES
    fi
    export RUST_TEST_THREADS=$max_threads
  '';
  checkFlags = [
    "--skip=service::message::tests::test_node_announcement_validate"
    "--skip=tests::test_announcement_relay"
    "--skip=tests::commands::rad_remote"
    # https://radicle.zulipchat.com/#narrow/stream/369277-heartwood/topic/Flaky.20tests/near/438352360
    "--skip=tests::e2e::test_connection_crossing"
    # https://radicle.zulipchat.com/#narrow/stream/369277-heartwood/topic/Clone.20Partial.20Fail.20Flake
    "--skip=rad_clone_partial_fail"
  ];

  postInstall = ''
    for page in $(find -name '*.adoc'); do
      asciidoctor -d manpage -b manpage $page
      installManPage ''${page::-5}
    done
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rad \
      --bash <($out/bin/rad completion bash) \
      --fish <($out/bin/rad completion fish) \
      --zsh <($out/bin/rad completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postFixup = ''
    for program in $out/bin/* ;
    do
      wrapProgram "$program" \
        --prefix PATH : "${
          lib.makeBinPath [
            gitMinimal
            man-db
            openssh
            xdg-utils
          ]
        }"
    done
  '';

  passthru.updateScript = ./update.sh;
  passthru.tests = {
    basic =
      runCommand "radicle-node-basic-test"
        {
          nativeBuildInputs = [
            jq
            openssh
            finalAttrs.finalPackage
          ];
        }
        ''
          set -e
          export RAD_HOME="$PWD/.radicle"
          mkdir -p "$RAD_HOME/keys"
          ssh-keygen -t ed25519 -N "" -f "$RAD_HOME/keys/radicle" > /dev/null
          jq -n '.node.alias |= "nix"' > "$RAD_HOME/config.json"

          rad config > /dev/null
          rad debug | jq -e '
              (.sshVersion | contains("${openssh.version}"))
            and
              (.gitVersion | contains("${gitMinimal.version}"))
          '

          touch $out
        '';
    nixos-run = nixosTests.radicle;
  };

  meta = {
    description = "Radicle node and CLI for decentralized code collaboration";
    longDescription = ''
      Radicle is an open source, peer-to-peer code collaboration stack built on Git.
      Unlike centralized code hosting platforms, there is no single entity controlling the network.
      Repositories are replicated across peers in a decentralized manner, and users are in full control of their data and workflow.
    '';
    homepage = "https://radicle.xyz";
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      amesgen
      lorenzleutgeb
      defelo
    ];
    mainProgram = "rad";
  };
})
