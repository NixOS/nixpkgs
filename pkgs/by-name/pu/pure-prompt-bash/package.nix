{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "pure-prompt-bash";
  version = "0-unstable-2020-10-02";

  src = fetchFromGitHub {
    owner = "krashikiworks";
    repo = "pure-prompt-bash";
    rev = "110dfe79628bcdcdd585a586e6410cee4c702dc3";
    sha256 = "sha256-lTpD4sZd56pSMafhNhC4+zyyeldoJ3k8qEmTTdJkK9Y=";
  };

  strictDeps = true;
  installPhase = ''
    mkdir -p $out/share
    cp pure.bash $out/share/pure.bash
  '';

  meta = {
    description = "Pure, the minimal prompt for bash";
    homepage = "https://github.com/krashikiworks/pure-prompt-bash";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      matthewcroughan
    ];
  };
}
