{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "octorus";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "ushironoko";
    repo = "octorus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xVbLh1fe+59KxcZOtCoSAh6O+VdhAyBSGCPP3UZLidA=";
  };

  cargoHash = "sha256-mOHjNQWeEcoBS4OhPj5RRja+b1PCPAeOM49t7OUtx1s=";

  nativeBuildInputs = [ installShellFiles ];

  meta = {
    description = "TUI PR review tool for GitHub";
    homepage = "https://github.com/ushironoko/octorus";
    changelog = "https://github.com/ushironoko/octorus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "octorus";
  };
})
