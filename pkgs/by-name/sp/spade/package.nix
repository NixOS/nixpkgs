{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  stdenv,
  _experimental-update-script-combinators,
  nix-update-script,
  nix-update,
  writeScript,
  git,
  pkg-config,
  openssl,
  python314,
  rust-jemalloc-sys,
  swim,
  zstd,
}:

rustPlatform.buildRustPackage rec {
  pname = "spade";
  version = "0.21.0";

  src = fetchFromCodeberg {
    owner = "spade-lang";
    repo = "spade";
    rev = "v${version}";
    hash = "sha256-NzPF0AtqylQTgFVDtipHZt06rGRPXkHfR708UoxOpHE=";
    # only needed for vatch, which contains test data
    fetchSubmodules = true;
  };

  cargoHash = "sha256-PFupzHsIv8X1umYFcvXK5+tMBANw7d5La5VAPtKe4X8=";

  # TODO: somehow respect https://nixos.org/manual/nixpkgs/stable/#var-passthru-updateScript-commit
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    # rust + gitlab + fetchgit is a rare combo
    (writeScript "update-spade" ''
      VERSION="$(
        ${lib.getExe git} ls-remote --tags --sort -version:refname ${lib.escapeShellArg src.gitRepoUrl} \
          | cut -f2 | grep ^refs/tags/v | cut -d/ -f3- | cut -c2- \
          | sort --version-sort --reverse | head -n1
      )"
      exec ${lib.getExe nix-update} spade --version "$VERSION" "$@" --commit
    '')
    (nix-update-script {
      extraArgs = [
        "swim"
        "--commit"
      ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    rust-jemalloc-sys
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    python314
  ];
  env.NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-L${python314}/lib/${python314.libPrefix}/config-${python314.pythonVersion}-darwin -lpython${python314.pythonVersion}";

  cargoBuildFlags = [
    "--workspace"
    # TODO: --exclude the excluded crates listed in release.sh?
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # "Undefined symbols for architecture arm:" ...
    "--exclude=spade-surfer-plugin"
  ];

  passthru.tests = {
    inherit swim;
  };

  meta = {
    description = "Better hardware description language";
    homepage = "https://codeberg/spade-lang/spade";
    changelog = "https://codeberg.org/spade-lang/spade/src/branch/main/CHANGELOG.md";
    # compiler is eupl12, spade-lang stdlib is both asl20 and mit
    license = with lib.licenses; [
      eupl12
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "spade";
  };
}
