{
  lib,
  stdenvNoCC,
  fetchFromGitHub,

  bash,
  gh,
  git,
  fzf,
  gnused,
  gawk,

  makeWrapper,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "gh-workon";
  version = "0-unstable-2025-02-14";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gh-workon";
    rev = "5018894c7a0c9b433db16cd69ad9a46cf46ba80e";
    hash = "sha256-rFfyR44IgL1DerFbzVPSHk1fltDbln2Fh2QQTTashac=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [ bash ];

  strictDeps = true;

  runtimeDeps = [
    gh
    git
    fzf
    gnused
    gawk
  ];

  installPhase = ''
    runHook preInstall
    install -D -m755 "gh-workon" "$out/bin/gh-workon"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/gh-workon" \
      --prefix PATH : "${lib.makeBinPath finalAttrs.runtimeDeps}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitHub CLI extension to create git branches and worktrees from GitHub issues";
    homepage = "https://github.com/chmouel/gh-workon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      vdemeester
      chmouel
    ];
    mainProgram = "gh-workon";
    inherit (gh.meta) platforms;
  };
})
