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
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "nvie";
    repo = "git-toolbelt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ANqv/iIDUyy2G4pKSw+2sutMEA0WhPN3OKfPTm5lwDU=";
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
    description = "A suite of useful Git commands that aid with scripting or every day command line usage";
    homepage = "https://github.com/nvie/git-toolbelt";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.all;
  };
})
