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

  cargoHash = "sha256-m07/fNuF78+PtG/trXZq9gllmKTt0w5BSMsq2UTKBbY=";

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
    mainProgram = "preserves-tool";
  };
}
