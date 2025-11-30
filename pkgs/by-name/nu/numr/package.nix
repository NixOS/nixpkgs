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
  pname = "numr";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "nasedkinpv";
    repo = "numr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tDQxDU/CrzZvXjsVSkUtDHX53WddFt6G8RBrHd8mXyg=";
  };

  cargoHash = "sha256-4Ig35ev3L2Sr8m4JsQVv/3lSLDc9RxSFMYeI+N+Wg7A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text calculator for natural language expressions with a vim-style TUI";
    longDescription = ''
      Text calculator inspired by Numi - natural language expressions, variables, unit conversions.
    '';
    homepage = "https://github.com/nasedkinpv/numr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "numr";
  };
})
