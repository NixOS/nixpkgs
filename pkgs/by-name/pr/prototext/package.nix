{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  protobuf,
  versionCheckHook,

  # passthru
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prototext";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "prototools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ka/Pg/YMrRPYaUO4M1fdevLSPyZ+8XhWYa2EQu3Xq6o=";
  };

  cargoHash = "sha256-5DgWKXYzrEB/3l2uDs2vc/VwRMlZ5trwJhor4ZnHEaw=";

  cargoBuildFlags = [
    "-p"
    "prototext"
  ];
  cargoTestFlags = [
    "-p"
    "prototext"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # The roundtrip tests compare with protoc's decoding; without it, they skip.
  nativeCheckInputs = [ protobuf ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd prototext \
      --bash <(PROTOTEXT_COMPLETE=bash $out/bin/prototext) \
      --zsh <(PROTOTEXT_COMPLETE=zsh $out/bin/prototext) \
      --fish <(PROTOTEXT_COMPLETE=fish $out/bin/prototext)
    $out/bin/prototext-gen-man $out/share/man/man1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # Only v-prefixed release tags: the repository also has workshop tags
  # (grehack2026-*), which are not versions.
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Lossless converter between binary protobuf and enhanced textproto";
    longDescription = ''
      prototext decodes binary protobuf to an enhanced textproto and encodes
      it back, byte for byte, with or without the message's schema. Given a
      schema database it infers the message type, and it reports every
      encoding anomaly it meets (non-canonical varints, unknown fields,
      wire-type mismatches) in the text, so that the round trip stays
      lossless.
    '';
    homepage = "https://github.com/douzebis/prototools";
    changelog = "https://github.com/douzebis/prototools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "prototext";
    platforms = lib.platforms.unix;
  };
})
