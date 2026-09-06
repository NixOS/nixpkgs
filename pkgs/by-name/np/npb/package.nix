{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  git,
  nix-eval-jobs,
  nix-output-monitor,
  versionCheckHook,
  nix-update-script,
}:
let
  # Use the version of nix that came with nix-eval-jobs per the upstream npb
  # packaging.  This (a) keeps closure sizes down, since it means this package
  # doesn't pull in both Nixpkgs' nix and nix-eval-jobs' nix, (b) removes any
  # risk of incompatibilities between calls to nix inside and outside
  # nix-eval-jobs, and (c) means that -- at time of writing -- we automatically
  # get at least version v2.35 of nix, which npb needs, even though the default
  # Nixpkgs nix version is v2.34.
  inherit (nix-eval-jobs) nix;

  buildCanExecuteHost = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npb";
  version = "1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "samestep";
    repo = "npb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pXatlxVJnrt8JFf+TPcUAL1U5mz4kWn8qfRtVHekYjA=";
  };

  cargoHash = "sha256-pZAaTweVR/JkTdtB4/FtXfSDPFTl1+cEdqx5finWMBk=";

  nativeBuildInputs = lib.optional buildCanExecuteHost installShellFiles;

  env = {
    GIT_BIN = lib.getExe git;
    NIX_BIN =
      # nix must be at least v2.35, as npb depends on the lazy source copying
      # added in that version.
      assert lib.versionAtLeast nix.version "2.35";
      lib.getExe nix;
    NIX_STORE_BIN = lib.getExe' nix "nix-store";
    NIX_INSTANTIATE_BIN = lib.getExe' nix "nix-instantiate";
    NIX_EVAL_JOBS_BIN = lib.getExe nix-eval-jobs;
    NOM_BIN = lib.getExe nix-output-monitor;
  };

  postInstall = lib.optionalString buildCanExecuteHost ''
    completion_tmp_dir="$(mktemp -d --tmpdir)"
    args=()
    for shell in bash fish zsh; do
        "$out"/bin/npb --completions "$shell" > "$completion_tmp_dir"/"$shell"
        args+=("--$shell" "$completion_tmp_dir"/"$shell")
    done
    installShellCompletion --cmd npb "''${args[@]}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nixpkgs build comparison tool";
    longDescription = ''
      A CLI tool to generate reports on the differences in build outcomes
      between a pair of Nixpkgs commits.
    '';
    mainProgram = "npb";
    homepage = "https://github.com/samestep/npb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      samestep
      me-and
    ];
  };
})
