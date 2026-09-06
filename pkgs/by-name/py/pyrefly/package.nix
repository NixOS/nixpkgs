{
  lib,
  bash,
  replaceVars,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "1.3.0-dev.4";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-f7GAfeh4vdLCSBvM4nw6ssvUZryrbdxkQKFyJSevDVI=";
  };

  buildAndTestSubdir = "pyrefly";

  cargoHash = "sha256-K9b3Zh/8LNhkpmRe1csAvtcceF6GXRlwYKd8tlF8y9M=";

  buildInputs = [ rust-jemalloc-sys ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  patches = [
    (replaceVars ./fix-shebang.patch { bash = lib.getExe bash; })
  ];

  # redirect tests writing to /tmp
  preCheck = ''
    export TMPDIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
})
