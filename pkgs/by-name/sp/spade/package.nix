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
  python312,
  swim,
}:

rustPlatform.buildRustPackage rec {
  pname = "spade";
  version = "0.13.0";

  src = fetchFromGitLab {
    owner = "spade-lang";
    repo = "spade";
    rev = "v${version}";
    hash = "sha256-eWeEbwIm+PC0XHmvV3xZqUIcA01arnalbGFtPTUP9tg=";
    # only needed for vatch, which contains test data
    fetchSubmodules = true;
  };

  cargoHash = "sha256-YMUeHr9eUOYIcO7PbaFgZa0Ib10GMF+jT10ZCSG7PNo=";

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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ python312 ];
  env.NIX_CFLAGS_LINK = lib.optionalString stdenv.hostPlatform.isDarwin "-L${python312}/lib/python3.12/config-3.12-darwin -lpython3.12";

  passthru.tests = {
    inherit swim;
  };

  meta = with lib; {
    description = "Better hardware description language";
    homepage = "https://gitlab.com/spade-lang/spade";
    changelog = "https://gitlab.com/spade-lang/spade/-/blob/${src.rev}/CHANGELOG.md";
    # compiler is eupl12, spade-lang stdlib is both asl20 and mit
    license = with licenses; [
      eupl12
      asl20
      mit
    ];
    maintainers = with maintainers; [ pbsds ];
    mainProgram = "spade";
  };
}
