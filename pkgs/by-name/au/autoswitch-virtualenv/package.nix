{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgs,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autoswitch-virtualenv";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = "zsh-autoswitch-virtualenv";
    tag = finalAttrs.version;
    hash = "sha256-j2YX+OcYbvS2G/KUNzcWbJepm9bZlegp1r8ZjcY6Nnw=";
  };

  dontBuild = true;
  nativeBuildInputs = [ installShellFiles ];
  installPhase = ''
    install -Dm755 autoswitch_virtualenv.plugin.zsh $out/autoswitch-virtualenv.plugin.zsh
  '';

  postPatch = ''
    substituteInPlace ./autoswitch_virtualenv.plugin.zsh \
      --replace-fail "virtualenv" "${lib.getExe' pkgs.virtualenv "virtualenv"}" \
      --replace-fail "/usr/bin/stat" "${lib.getExe' pkgs.coreutils "stat"}" \
      --replace-fail "/bin/rm" "${lib.getExe' pkgs.coreutils "rm"}" \
      --replace-fail "/bin/ls" "${lib.getExe' pkgs.coreutils "ls"}" \
      --replace-fail "/bin/mkdir" "${lib.getExe' pkgs.coreutils "mkdir"}"
  '';

  meta = {
    description = "ZSH plugin that switches python virtualenvs automatically as you move between directories";
    homepage = "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.dogethebeast ];
  };
})
