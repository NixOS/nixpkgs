{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pure-prompt";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "sindresorhus";
    repo = "pure";
    rev = "v${version}";
    sha256 = "sha256-LfrZUv0UMVyygPd1RAv2EIWEvds2n0iEG8G2q7h5izM=";
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
}
