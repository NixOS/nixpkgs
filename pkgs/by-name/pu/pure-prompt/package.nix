{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pure-prompt";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-UQ0hP3qJd4Qxiw1LXPdb9d0Dc4OSD3HJpgYzaCfujno=";
  };

  strictDeps = true;
  installPhase = ''
    OUTDIR="$out/share/zsh/site-functions"
    mkdir -p "$OUTDIR"
    cp pure.zsh "$OUTDIR/prompt_pure_setup"
    cp async.zsh "$OUTDIR/async"
  '';

  meta = {
    description = "Pretty, minimal and fast ZSH prompt";
    homepage = "https://github.com/sindresorhus/pure";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      euxane
      pablovsky
    ];
  };
})
