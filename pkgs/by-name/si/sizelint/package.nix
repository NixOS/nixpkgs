{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  git,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sizelint";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "sizelint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QA8K17opiA1HAyMLuete/1SA5jph0M6YvsS7Z4cr0T8=";
  };

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  cargoHash = "sha256-ml5qho/hk9akgOqPaTK8yG29mSpsksCzDaed7Izk078=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sizelint \
      --bash <($out/bin/sizelint completions bash) \
      --fish <($out/bin/sizelint completions fish) \
      --zsh <($out/bin/sizelint completions zsh)
  '';

  meta = {
    description = "Lint your file tree based on file sizes";
    homepage = "https://github.com/a-kenji/sizelint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ a-kenji ];
    mainProgram = "sizelint";
  };
})
