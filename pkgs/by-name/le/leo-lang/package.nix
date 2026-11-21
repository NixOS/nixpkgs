{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  aws-lc,
  openssl,
  nix-update-script,
  curl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leo-lang";
  version = "4.4.6";

  src = fetchFromGitHub {
    owner = "aleo-labs-protocol";
    repo = "leo";
    tag = "leo-lang-v${finalAttrs.version}";
    hash = "sha256-zDQj+rHMVHT4FeCS/ZuW+o0dgeqiA1eo/FFxulyBNBA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-bFTFtrgY8nx4YuFVYhPcVnIfjczIUb7DHtJKUKMfXaw=";

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ rustPlatform.bindgenHook ];

  buildInputs = [
    aws-lc
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ curl ];

  preCheck = ''
    export RUST_LOG=debug
    export HOME=$TMPDIR
    mkdir -p "$HOME/.aleo"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/leo";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    # Keep only the generated CLI fixture suite disabled. Its scripts use /usr/bin/env
    # shebangs, and patching them for Nix changes the COMMANDS files that the suite
    # compares against fixture expectations.
    "--skip=cli_tests::"
  ];

  meta = {
    description = "Functional, statically-typed programming language built for writing private applications";
    homepage = "https://github.com/aleo-labs-protocol/leo";
    changelog = "https://github.com/aleo-labs-protocol/leo/releases/tag/leo-lang-v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ anstylian ];
    mainProgram = "leo";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
  };
})
