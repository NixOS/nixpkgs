{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
  openssh,
  protobuf,
  versionCheckHook,

  # passthru
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-seriate";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "prototools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zE8jDoPISjJg56cRjs0LJDDBQv9dWYAryg29RpZLsZU=";
  };

  cargoHash = "sha256-0r9goxXjNTPSdktSC7moIg39okYVFwEpoKwmSfQV23U=";

  # Two git subcommands: git-seriate, and git-seriate-fdp for the protobuf
  # descriptors embedded in executables.
  cargoBuildFlags = [
    "-p"
    "git-seriate"
    "-p"
    "git-seriate-fdp"
  ];
  cargoTestFlags = [
    "-p"
    "git-seriate"
    "-p"
    "git-seriate-fdp"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # The end-to-end tests check every tree they write with git fsck and sign
  # with ssh-keygen; one compares with protoc. Without them, they skip.
  nativeCheckInputs = [
    gitMinimal
    openssh
    protobuf
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-seriate \
      --bash <(GIT_SERIATE_COMPLETE=bash $out/bin/git-seriate) \
      --zsh <(GIT_SERIATE_COMPLETE=zsh $out/bin/git-seriate) \
      --fish <(GIT_SERIATE_COMPLETE=fish $out/bin/git-seriate)
    installShellCompletion --cmd git-seriate-fdp \
      --bash <(GIT_SERIATE_FDP_COMPLETE=bash $out/bin/git-seriate-fdp) \
      --zsh <(GIT_SERIATE_FDP_COMPLETE=zsh $out/bin/git-seriate-fdp) \
      --fish <(GIT_SERIATE_FDP_COMPLETE=fish $out/bin/git-seriate-fdp)
    GIT_SERIATE_GEN_MAN=$out/share/man/man1 $out/bin/git-seriate
    GIT_SERIATE_FDP_GEN_MAN=$out/share/man/man1 $out/bin/git-seriate-fdp
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Only v-prefixed release tags
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Store undated snapshots of files in git, and rebuild one linear history from them";
    longDescription = ''
      git-seriate keeps snapshots of a set of files, each taken at an unknown
      or uncertain time (extracted from binaries, collected from systems), as
      git branches, and orders them into one linear history whose commits
      change as little as possible from one to the next. git-seriate-fdp is
      git-seriate specialized for protobuf schemas: its extract command adds
      the FileDescriptorProto records a file embeds as a snapshot, so that
      a collection of binaries becomes a history of their schemas, and its
      advise command reports what that history can't merge into one schema
      database.
    '';
    homepage = "https://github.com/douzebis/prototools";
    changelog = "https://github.com/douzebis/prototools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "git-seriate";
    platforms = lib.platforms.unix;
  };
})
