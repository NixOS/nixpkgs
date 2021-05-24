{ lib, stdenv, fetchFromGitHub, git, gnupg, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "yadm";
  version = "3.1.0";

  buildInputs = [ git gnupg ];

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner  = "TheLocehiliosan";
    repo   = "yadm";
    rev    = version;
    sha256 = "0ga0p28nvqilswa07bzi93adk7wx6d5pgxlacr9wl9v1h6cds92s";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin yadm
    runHook postInstall
  '';

  postInstall = ''
    installManPage yadm.1
    installShellCompletion --cmd yadm \
      --zsh completion/zsh/_yadm \
      --bash completion/bash/yadm
  '';

  meta = {
    homepage = "https://github.com/TheLocehiliosan/yadm";
    description = "Yet Another Dotfiles Manager";
    longDescription = ''
      yadm is a dotfile management tool with 3 main features:
      * Manages files across systems using a single Git repository.
      * Provides a way to use alternate files on a specific OS or host.
      * Supplies a method of encrypting confidential data so it can safely be stored in your repository.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ abathur ];
    platforms = lib.platforms.unix;
  };
}
