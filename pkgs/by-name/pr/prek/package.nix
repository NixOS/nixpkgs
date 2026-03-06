{
  fetchFromGitHub,
  git,
  installShellFiles,
  lib,
  nix-update-script,
  python312,
  rustPlatform,
  stdenv,
  uv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prek";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "j178";
    repo = "prek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J4onCCHZ6DT2CtZ8q0nrdOI74UGDJhVFG2nWj+p7moE=";
  };

  cargoHash = "sha256-pR5NibzX5m8DcMxer0W1wowTJCesYaF852wpGiVboVg=";

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [
    git
    python312
    uv
  ];

  # many tests just do not work, as they require network access
  # best to disable all, as the upstream already tests everything
  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd prek \
      --bash <(COMPLETE=bash $out/bin/prek) \
      --fish <(COMPLETE=fish $out/bin/prek) \
      --zsh <(COMPLETE=zsh $out/bin/prek)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/j178/prek";
    description = "Reimagined version of pre-commit, built in Rust";
    longDescription = ''
      [pre-commit](https://pre-commit.com/) is a framework to run hooks written
      in many languages, and it manages the language toolchain and dependencies
      for running the hooks.

      `prek` is a reimagined version of pre-commit, built in Rust. It is
      designed to be a faster, dependency-free and drop-in alternative for it,
      while also providing some additional long-requested features.
    '';
    mainProgram = "prek";
    changelog = "https://github.com/j178/prek/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.knl ];
  };
})
