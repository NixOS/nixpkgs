{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nix-zsh-completions";
  version = "0.5.1-unstable-2025-12-12";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-zsh-completions";
    rev = "d4ae06bedb9a353ac894862d1d83f60ab4e2ccce";
    hash = "sha256-ogDhANf4MpVZn5sWZymT0EIjDMTLSHRGzNjHsw/dX8o=";
  };

  strictDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/zsh/{site-functions,plugins/nix}
    cp _* $out/share/zsh/site-functions
    cp *.zsh $out/share/zsh/plugins/nix

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/nix-community/nix-zsh-completions";
    description = "ZSH completions for Nix, NixOS, and NixOps";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      olejorgenb
      hedning
      ma27
      sebtm
    ];
  };
})
