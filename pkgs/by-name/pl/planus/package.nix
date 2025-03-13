{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "planus";
  version = "1.1.0";

  src = fetchCrate {
    pname = "planus-cli";
    inherit version;
    hash = "sha256-Eh/Mp/9TgEEH7QXhEVOK1qQDQuzrbM8GzWQtXM365qE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-INrW0WkT+CqoSvtLpBCTGeUk4fNpBzzgigbutklPpzg=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd planus \
      --bash <($out/bin/planus generate-completions bash) \
      --fish <($out/bin/planus generate-completions fish) \
      --zsh <($out/bin/planus generate-completions zsh)
  '';

  meta = with lib; {
    description = "Alternative compiler for flatbuffers";
    mainProgram = "planus";
    homepage = "https://github.com/planus-org/planus";
    changelog = "https://github.com/planus-org/planus/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
