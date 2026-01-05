{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "planus";
  version = "1.2.0";

  src = fetchCrate {
    pname = "planus-cli";
    inherit version;
    hash = "sha256-z1fXLXSk9xprKMCsbkvJfDB3qz9aR6Bslf517TyQ7qI=";
  };

  cargoHash = "sha256-igja5/FaYBrJSBc9Gw3091UorEV+UmlxPzfk5FYaWXo=";

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
    changelog = "https://github.com/planus-org/planus/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
