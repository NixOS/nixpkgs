{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,

  # passthru
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protoscan";
  version = "0.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "prototools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wNeO5GUz0XkUpdiIGp4xWXf7Ol2pmfnqspCbeTAKmKs=";
  };

  cargoHash = "sha256-4F/ZRjvaFPTJALcRZ0j8bMwIRAaTTghf4fCbx2+6z3M=";

  cargoBuildFlags = [
    "-p"
    "protoscan"
  ];
  cargoTestFlags = [
    "-p"
    "protoscan"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd protoscan \
      --bash <(PROTOSCAN_COMPLETE=bash $out/bin/protoscan) \
      --zsh <(PROTOSCAN_COMPLETE=zsh $out/bin/protoscan) \
      --fish <(PROTOSCAN_COMPLETE=fish $out/bin/protoscan)
    PROTOSCAN_GEN_MAN=$out/share/man/man1 $out/bin/protoscan
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
    description = "Find the protobuf descriptors embedded in any file";
    longDescription = ''
      protoscan scans a file (an executable, a shared library, a firmware
      image, an archive) for the protobuf FileDescriptorProto records it
      embeds, prints each one's file name, and can write them out as .pb
      files, which prototext decodes and reproto turns back into .proto
      sources.
    '';
    homepage = "https://github.com/douzebis/prototools";
    changelog = "https://github.com/douzebis/prototools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "protoscan";
    platforms = lib.platforms.unix;
  };
})
