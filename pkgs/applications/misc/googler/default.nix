{
  lib,
  stdenv,
  fetchFromGitHub,
  python,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "googler";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PgWg396AQ15CAnfTXGDpSg1UXx7mNCtknEjJd/KV4MU=";
  };

  buildInputs = [ python ];

  nativeBuildInputs = [ installShellFiles ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installShellCompletion --bash --name googler.bash auto-completion/bash/googler-completion.bash
    installShellCompletion --fish auto-completion/fish/googler.fish
    installShellCompletion --zsh auto-completion/zsh/_googler
  '';

  meta = with lib; {
    homepage = "https://github.com/jarun/googler";
    description = "Google Search, Google Site Search, Google News from the terminal";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      koral
      Br1ght0ne
    ];
    platforms = python.meta.platforms;
    mainProgram = "googler";
  };
}
