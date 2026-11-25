{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  protobuf,
  python3,
  rust-jemalloc-sys,
  versionCheckHook,

  # passthru
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protoback";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "prototools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zE8jDoPISjJg56cRjs0LJDDBQv9dWYAryg29RpZLsZU=";
  };

  cargoHash = "sha256-0r9goxXjNTPSdktSC7moIg39okYVFwEpoKwmSfQV23U=";

  cargoBuildFlags = [
    "-p"
    "protoback"
  ];
  cargoTestFlags = [
    "-p"
    "protoback"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # protoback's allocator: the system jemalloc, as the Rust hooks require.
  buildInputs = [ rust-jemalloc-sys ];

  # Some tests compile what protoback writes with protoc, and skip without it;
  # the plugin tests run their plugins with python3.
  nativeCheckInputs = [
    protobuf
    python3
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd protoback \
      --bash <(PROTOBACK_COMPLETE=bash $out/bin/protoback) \
      --zsh <(PROTOBACK_COMPLETE=zsh $out/bin/protoback) \
      --fish <(PROTOBACK_COMPLETE=fish $out/bin/protoback)
    PROTOBACK_GEN_MAN=$out/share/man/man1 $out/bin/protoback
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
    description = "Give back the .proto sources a protobuf descriptor set was compiled from";
    longDescription = ''
      protoback reads protobuf descriptors (FileDescriptorSet files, or the
      FileDescriptorProto records protoscan extracts from a binary) and
      writes back the .proto sources they were compiled from: messages,
      enums, services, options and comments where the descriptors keep
      them. Its output can be made to compile with protoc, and it reports
      what the descriptors don't let it rebuild exactly.
    '';
    homepage = "https://github.com/douzebis/prototools";
    changelog = "https://github.com/douzebis/prototools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "protoback";
    platforms = lib.platforms.unix;
  };
})
