{
  lib,
  stdenv,
  rustPlatform,
  fetchCrate,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "preserves-tools";
  version = "4.996.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Uyh5mXCypX3TDxxJtnTe6lBoVI8aqdG56ywn7htDGUY=";
  };

  cargoHash = "sha256-rDo/jA4b+GV90SKM82JcGTX1pcAQUeBrLvGwU/geGOw=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd preserves-tool \
      --bash <($out/bin/preserves-tool completions bash) \
      --fish <($out/bin/preserves-tool completions fish) \
      --zsh <($out/bin/preserves-tool completions zsh)
  '';

  meta = {
    description = "Command-line utilities for working with Preserves documents";
    homepage = "https://preserves.dev/doc/preserves-tool.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "preserves-tool";
  };
}
