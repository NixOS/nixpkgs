{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "geminicommit";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "tfkhdyt";
    repo = "geminicommit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QUI5JI1udOo3IOXegoes3pwwgSfxXIjxXIPsA5SuAJo=";
  };

  vendorHash = "sha256-AFm+1RQ6sMSe+kY/cw1Ly/8WEj2/yk0nJQiEJzV6jKg=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      cmd = finalAttrs.meta.mainProgram;
    in
    lib.optionalString (with stdenv; buildPlatform.canExecute hostPlatform) ''
      # `geminicommit` requires write permissions to $HOME for its `config.toml`
      # ... which is automatically initiated on startup
      export HOME=$(mktemp -d)

      for shell in bash zsh fish; do
        installShellCompletion \
          --cmd "${cmd}" \
          --"$shell" <($out/bin/"${cmd}" completion "$shell")
      done
    '';

  meta = {
    description = "CLI that generates git commit messages with Google Gemini AI";
    homepage = "https://github.com/tfkhdyt/geminicommit";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bryango ];
    mainProgram = "geminicommit";
  };
})
