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
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-xZ+HxB7UQUeVaPK15M6if+7aW4M+4ub397zL7DfduIw=";
  };

  buildAndTestSubdir = "pyrefly";

  cargoHash = "sha256-hPGV6IfgpQy+nd6jHR1bf6mFW6ppePk+Dvt1cC2dI+U=";

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

  # avoid autoupdates for *-dev.* tags
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^([\\d.]+)$" ];
  };

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
