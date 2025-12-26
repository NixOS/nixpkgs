{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  git,
  fzf,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "git-toolbelt";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "nvie";
    repo = "git-toolbelt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6ubxMGDi5ocSh8q8rDujxpViT1OmVi7JzH+R6V/88UQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    git
    fzf # needed by git-fixup-with
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 git-* -t "$out"/bin

    for exe in "$out"/bin/*; do
        wrapProgram "$exe" \
            --prefix PATH : "$out"/bin:${lib.makeBinPath finalAttrs.buildInputs}
    done

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/nvie/git-toolbelt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Suite of useful Git commands that aid with scripting or every day command line usage";
    homepage = "https://github.com/nvie/git-toolbelt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
