{
  stdenv,
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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "nasedkinpv";
    repo = "numr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fa/F1bE/iUdtLe4kgHIQF3lcT/LLyUgdiYSgE9pCCSc=";
  };

  cargoHash = "sha256-onIhdgcB7MDiLCOi4qMysnu3VVpZ138jro9mZXDp9LI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ];

  env.OPENSSL_NO_VENDOR = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Text calculator inspired by Numi - natural language expressions, variables, unit conversions";
    homepage = "https://github.com/nasedkinpv/numr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "numr";
  };
})
