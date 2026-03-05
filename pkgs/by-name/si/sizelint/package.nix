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
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "sizelint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1k1+7fVWhflEKyhOlb7kMn2xqeAM6Y5N9uHtOJvVn4A=";
  };

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  cargoHash = "sha256-Z+pmlp/0LlKfc4QLosePw7TdLFYe6AnAVOJSw2DzlfI=";

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
