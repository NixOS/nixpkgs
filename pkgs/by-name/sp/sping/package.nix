{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sping";
  version = "1.5.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LambdaBytes";
    repo = "sping";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jkyNQFpNBvtxb5mwCBdLj0x8WlOzeZCRxZ+wLV9StRk=";
  };

  cargoHash = "sha256-41a3kI6ouelM8hQX+oX0F7gKvnBMFJXzSOcNM1hAqag=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage target/assets/man/sping.1
    installShellCompletion --bash target/assets/completions/sping.bash
    installShellCompletion --zsh target/assets/completions/_sping
    installShellCompletion --fish target/assets/completions/sping.fish
  '';

  meta = {
    description = "Terminal-native real-time connectivity monitor with network context diagnostics";
    homepage = "https://github.com/LambdaBytes/sping";
    changelog = "https://github.com/LambdaBytes/sping/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "sping";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
