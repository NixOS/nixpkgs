{ stdenv, fetchFromGitHub, git, gnupg }:

let version = "2.3.0"; in
stdenv.mkDerivation {
  pname = "yadm";
  inherit version;

  buildInputs = [ git gnupg ];

  src = fetchFromGitHub {
    owner  = "TheLocehiliosan";
    repo   = "yadm";
    rev    = version;
    sha256 = "1by21dh48qbi33wlyyvdwz7ac1lxrblzcr5v7hlnc4cbcgvgs1a0";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dt $out/bin $src/yadm
    install -Dt $out/share/man/man1 $src/yadm.1
    install -D $src/completion/yadm.zsh_completion $out/share/zsh/site-functions/_yadm
    install -D $src/completion/yadm.bash_completion $out/share/bash-completion/completions/yadm.bash
    runHook postInstall
  '';

  meta = {
    homepage = https://github.com/TheLocehiliosan/yadm;
    description = "Yet Another Dotfiles Manager";
    longDescription = ''
      yadm is a dotfile management tool with 3 main features:
      * Manages files across systems using a single Git repository.
      * Provides a way to use alternate files on a specific OS or host.
      * Supplies a method of encrypting confidential data so it can safely be stored in your repository.
    '';
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
