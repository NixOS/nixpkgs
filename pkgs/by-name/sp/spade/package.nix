{
  lib,
  rustPlatform,
  fetchFromGitLab,
  stdenv,
  nix-update,
  writeScript,
  git,
  python312,
}:

rustPlatform.buildRustPackage rec {
  pname = "spade";
  version = "0.9.0";

  src = fetchFromGitLab {
    owner = "spade-lang";
    repo = "spade";
    rev = "v${version}";
    hash = "sha256-DVvdCt/t7aA2IAs+cL6wT129PX8s3P5gHawcLAvAAGw=";
    # only needed for vatch, which contains test data
    fetchSubmodules = true;
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "codespan-0.12.0" = "sha256-3F2006BR3hyhxcUTaQiOjzTEuRECKJKjIDyXonS/lrE=";
    };
  };

  # rust + gitlab is a rare combo
  passthru.updateScript = [
    (writeScript "update-spade" ''
      VERSION="$(
        ${lib.getExe git} ls-remote --tags --sort -version:refname ${lib.escapeShellArg src.gitRepoUrl} \
          | cut -f2 | grep ^refs/tags/v | cut -d/ -f3- | cut -c2- \
          | sort --version-sort --reverse | head -n1
      )"
      exec ${lib.getExe nix-update} --version "$VERSION" "$@"
    '')
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ python312 ];
  env.NIX_CFLAGS_LINK = lib.optionals stdenv.hostPlatform.isDarwin "-L${python312}/lib/python3.12/config-3.12-darwin -lpython3.12";

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
