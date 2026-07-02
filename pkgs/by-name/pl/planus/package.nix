{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "planus";
  version = "1.3.0";

  src = fetchCrate {
    pname = "planus-cli";
    inherit (finalAttrs) version;
    hash = "sha256-2ReR9cCB3kv1a9Ep60pshTI5B5jdimM0PBjvIOUdV5o=";
  };

  cargoHash = "sha256-0rDvYsEWEKDoPTCgeZ9Yxu1jc68LEzoS0BuzYsAdInQ=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd planus \
      --bash <($out/bin/planus generate-completions bash) \
      --fish <($out/bin/planus generate-completions fish) \
      --zsh <($out/bin/planus generate-completions zsh)
  '';

  meta = {
    description = "Alternative compiler for flatbuffers";
    mainProgram = "planus";
    homepage = "https://github.com/planus-org/planus";
    changelog = "https://github.com/planus-org/planus/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
})
