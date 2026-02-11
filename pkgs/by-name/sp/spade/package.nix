{
  lib,
  rustPlatform,
  fetchFromGitLab,
  stdenv,
  _experimental-update-script-combinators,
  nix-update-script,
  nix-update,
  writeScript,
  git,
  pkg-config,
  openssl,
  python314,
  swim,
}:

rustPlatform.buildRustPackage rec {
  pname = "spade";
  version = "0.16.0";

  src = fetchFromGitLab {
    owner = "spade-lang";
    repo = "spade";
    rev = "v${version}";
    hash = "sha256-Q9LiyCkrHQxnTorAqPOykS4F06c01pYPW9t82xEn6DY=";
    # only needed for vatch, which contains test data
    fetchSubmodules = true;
  };

  cargoHash = "sha256-zuj34DpQKu7uWYgL/JTq7zLTPvZKQ/eedBXrkN1Pvg0=";

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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    python314
  ];
  env.NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-L${python314}/lib/python3.14/config-3.14-darwin -lpython3.14";

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
    homepage = "https://gitlab.com/spade-lang/spade";
    changelog = "https://gitlab.com/spade-lang/spade/-/blob/${src.rev}/CHANGELOG.md";
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
