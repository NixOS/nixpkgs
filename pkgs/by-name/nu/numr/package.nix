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
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "nasedkinpv";
    repo = "numr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FcvXhgao8l5vBggziAMmvmxKZ1uIr8UDyk64RTohYMg=";
  };

  cargoHash = "sha256-LHTAhGHc0hnq1lzYkQhAO3VhwbzVi0vN1D6VBgEV/Js=";

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
