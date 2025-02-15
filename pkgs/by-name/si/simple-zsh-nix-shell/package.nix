{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "simple-zsh-nix-shell";
  version = "0-unstable-2024-12-13";

  src = fetchFromGitHub {
    owner = "goolord";
    repo = "simple-zsh-nix-shell";
    rev = "f8b82db8b4a4d4a3d31d43697e590207eca29da1";
    sha256 = "sha256-lOf5IlToVvh8VqmGthwT2yAhSNxd/0sO2Edzpgh24Ao=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    install -D *.{sh,zsh} -t $out/share/simple-zsh-nix-shell
  '';

  meta = {
    description = "Zsh plugin that lets you use zsh in nix shells";
    homepage = "https://github.com/goolord/simple-zsh-nix-shell";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ istudyatuni ];
  };
}
