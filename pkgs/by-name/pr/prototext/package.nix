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
  version = "0.3.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "prototools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PTOmgGRMhMrss2HBwgLp7ub7uNVncNVkT63W+7wqk3U=";
  };

  cargoHash = "sha256-aHobnBJJWsMem2oehd8pNwlrXHdjnY/it20mGK9+N2s=";

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
    PROTOTEXT_GEN_MAN=$out/share/man/man1 $out/bin/prototext
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
