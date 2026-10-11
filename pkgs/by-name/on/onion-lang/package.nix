{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "onion-lang";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "sjrsjz";
    repo = "onion-lang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FrDDD6eGdMPxobiL3Mb3ZwRDBqxb7ZSkT1NNoioxvas=";
  };

  cargoHash = "sha256-gRjqoaiXm30J1vsOr6mqwLiqufsJ9DklhEz2BEk6VGg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Onion programming language";
    longDescription = ''
      A modern, functional programming language featuring an
      expressive syntax, a powerful layered concurrency model, and a
      strong emphasis on safety and developer productivity.

      The name Onion is inspired by its core design philosophy: a
      layered execution model that provides natural state isolation
      and abstraction, much like the layers of an onion.
    '';
    homepage = "https://github.com/sjrsjz/onion-lang";
    changelog = "https://github.com/sjrsjz/onion-lang/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "onion";
  };
})
