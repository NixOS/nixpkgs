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
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "a-kenji";
    repo = "sizelint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m8Pd7Bnz++5k6J4stbKVd8Y596Y+52xbF0zFJVhdfzI=";
  };

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  cargoHash = "sha256-7cDZrRNTGPdzbvVNt3/HTp7PgoH2txX26RCxdpeo4dM=";

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
