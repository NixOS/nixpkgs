{
  lib,
  stdenv,
  git,
  perl,
  ncurses,
  coreutils,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "diff-so-fancy";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "so-fancy";
    repo = "diff-so-fancy";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-mEVRwkfVK/qmOeU37hSxmO2t0z0TY4MWOjkt6hICQQ4=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    perl # needed for patchShebangs
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/diff-so-fancy

    # diff-so-fancy executable searches for it's library relative to
    # itself, so we are copying executable to lib, and only symlink it
    # from bin/
    cp diff-so-fancy $out/lib/diff-so-fancy
    cp -r lib $out/lib/diff-so-fancy
    ln -s $out/lib/diff-so-fancy/diff-so-fancy $out/bin

    # ncurses is needed for `tput`
    wrapProgram $out/lib/diff-so-fancy/diff-so-fancy \
      --prefix PATH : "${git}/share/git/contrib/diff-highlight" \
      --prefix PATH : "${git}/bin" \
      --prefix PATH : "${coreutils}/bin" \
      --prefix PATH : "${ncurses.out}/bin"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/so-fancy/diff-so-fancy";
    description = "Good-looking diffs filter for git";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    longDescription = ''
      diff-so-fancy builds on the good-lookin' output of git contrib's
      diff-highlight to upgrade your diffs' appearances.
    '';
    maintainers = with lib.maintainers; [
      fpletz
      ma27
    ];
    mainProgram = "diff-so-fancy";
  };
})
