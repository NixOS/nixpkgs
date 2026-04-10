{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  bash,
  git,
  python3,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "git-tools";
  version = "2025.08";

  src = fetchFromGitHub {
    owner = "MestreLion";
    repo = "git-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DuhvepcDXk+UTFbvmv5V/EGP9ZEnHBYk7ARm/z0gTLY=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    bash
    git
    python3
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
  postInstall = ''
    installManPage \
      man1/*.1
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/git-restore-mtime";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/MestreLion/git-tools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Assorted git tools, including git-restore-mtime";
    homepage = "https://github.com/MestreLion/git-tools";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aduh95 ];
    platforms = lib.platforms.all;
  };
})
