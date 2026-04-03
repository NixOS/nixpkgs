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
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "micahkepe";
    repo = "jsongrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A4cBHIRXmjpRSJtUNNPGOfSOFQG4om5QFa9xw4MeYj8=";
  };

  cargoHash = "sha256-RQLMQ2jEtqh7km4FWhBaWuw9QY4B4O50DbPdBO+hcW4=";

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
