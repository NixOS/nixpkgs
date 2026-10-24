{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  git,
  gnused,
  jq,
  gh,
  glab,
  makeWrapper,
  installShellFiles,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-native-issue";
  version = "1.3.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "remenoscodes";
    repo = "git-native-issue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XVdv3awJGqIzGtOsIbuDndHl4biNfQnLsgzSkTe/j1c=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin

    for f in $out/bin/*; do
      # "git-issue-lib" is not executable
      [ "$(basename "$f")" = "git-issue-lib" ] && continue
      wrapProgram $f --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          git
          gnused
          jq
          gh
          glab
        ]
      }
    done

    installManPage doc/*.1

    installShellCompletion --cmd git-issue \
      --bash contrib/completion/git-issue.bash \
      --zsh contrib/completion/git-issue.zsh
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Distributed issue tracking embedded in Git — track issues locally, sync anywhere, no server required";
    homepage = "https://github.com/remenoscodes/git-native-issue";
    changelog = "https://github.com/remenoscodes/git-native-issue/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "git-issue";
    platforms = lib.platforms.all;
  };
})
