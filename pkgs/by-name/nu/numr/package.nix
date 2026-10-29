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
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "nasedkinpv";
    repo = "numr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dx5Ow+trL0/gVKj0IOAVwwgNMl4ZwF5K7MEi6fv/QYc=";
  };

  cargoHash = "sha256-8illKr1unCiZRlcpuzBSCJ/H7HJPW2cHDLq1vF76vss=";

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
