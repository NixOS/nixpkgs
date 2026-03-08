{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "geminicommit";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tfkhdyt";
    repo = "geminicommit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BLCnBym69O6s4UnogopcccI5PnniOFJ3BcWFyxEsUUI=";
  };

  vendorHash = "sha256-FFWptw1kSbl7f8DR3FrM0jAfr06NaJT+i/8ZaQjav/E=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall =
    let
      cmd = finalAttrs.meta.mainProgram;
      goDefaultCmd = finalAttrs.pname;
    in
    # The official github released binary is renamed since v0.4.1,
    # see: https://github.com/tfkhdyt/geminicommit/releases/tag/v0.4.1
    # Here we link the old name (which is also the `go build` default name)
    # for backward compatibility:
    ''
      mv $out/bin/${goDefaultCmd} $out/bin/${cmd}
      ln -s $out/bin/${cmd} $out/bin/${goDefaultCmd}
    ''
    + lib.optionalString (with stdenv; buildPlatform.canExecute hostPlatform) ''
      # `gmc` requires write permissions to $HOME for its `config.toml`
      # ... which is automatically initiated on startup
      export HOME=$(mktemp -d)

      for shell in bash zsh fish; do
        installShellCompletion \
          --cmd "${cmd}" \
          --"$shell" <($out/bin/"${cmd}" completion "$shell")
      done
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "CLI that generates git commit messages with Google Gemini AI";
    homepage = "https://github.com/tfkhdyt/geminicommit";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ bryango ];
    mainProgram = "gmc";
  };
})
