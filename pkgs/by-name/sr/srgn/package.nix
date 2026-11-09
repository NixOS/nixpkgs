{
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "srgn";
  version = "0.14.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alexpovel";
    repo = "srgn";
    rev = "srgn-v${finalAttrs.version}";
    hash = "sha256-K9pHtsPD3Ab0I68y+QjHhzQwYBIQoJ0rc/fRomBDzVg=";
  };

  cargoHash = "sha256-jgxA8T7Q7QXw7J53SDHpLEv2mFtgv89uGrbKlxzmhJQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd srgn "--$shell" <("$out/bin/srgn" --completions "$shell")
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Code surgeon for precise text and code transplantation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      adda
      magistau
    ];
    mainProgram = "srgn";
    homepage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/";
    downloadPage = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/tag/${finalAttrs.src.rev}";
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/blob/${finalAttrs.src.rev}/CHANGELOG.md";
  };
})
