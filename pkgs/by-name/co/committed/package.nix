{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  git,
  libz,
}:
let
  version = "1.1.5";
in
rustPlatform.buildRustPackage {
  pname = "committed";
  inherit version;

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "committed";
    tag = "v${version}";
    hash = "sha256-puv64/btSEkxGNhGGkh2A08gI+EIHWjC+s+QQDKj/ZQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-fW3TqI26xggUKfzI11YCO8bpotd3aO6pdu1CHhtiShs=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # Until upstream bumps the libz-sys dependency to >= 1.1.15 the build fails on unstable
    # nixpkgs with macOS, because the following commit is not part of libz-sys < 1.1.15:
    # https://github.com/madler/zlib/commit/4bd9a71f3539b5ce47f0c67ab5e01f3196dc8ef9
    # Instead, use the nixpkgs libz so that libz-sys does not have to be built.
    libz
  ];

  nativeCheckInputs = [
    git
  ];

  # Ensure libgit2 can read user.name and user.email for `git_signature_default`.
  # https://github.com/crate-ci/committed/blob/v1.1.5/crates/committed/tests/cmd.rs#L126
  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name nobody
    git config --global user.email no@where
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/crate-ci/committed";
    changelog = "https://github.com/crate-ci/committed/blob/v${version}/CHANGELOG.md";
    description = "Nitpicking commit history since beabf39";
    mainProgram = "committed";
    license = [
      lib.licenses.asl20 # or
      lib.licenses.mit
    ];
    maintainers = [ lib.maintainers.pigeonf ];
  };
}
