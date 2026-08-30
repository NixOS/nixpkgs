{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  stdenvNoCC,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jsongrep";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "micahkepe";
    repo = "jsongrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rDt4jtrC+KuPKdEoReVWW8R9/sKBnalnRuB4bj1tzas=";
  };

  cargoHash = "sha256-VJ8ZB3oVppMRsSvpVOF1SIvOtI0rcS8elJEweoum/lY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd jg \
        --"$shell" <("$out"/bin/jg generate shell "$shell")
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/micahkepe/jsongrep/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "JSONPath-inspired query language";
    longDescription = ''
      `jsongrep` is a command-line tool and Rust library for querying
      JSON documents using regular path expressions.
    '';
    homepage = "https://github.com/micahkepe/jsongrep";
    license = lib.licenses.mit;
    mainProgram = "jg";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})
