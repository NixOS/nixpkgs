{ stdenv, fetchFromGitHub, python, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "googler";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0c480wzc7q4pks1f6mnayr580c73jhzshliz4hgznzc7zwcdf41w";
  };

  buildInputs = [ python ];

  nativeBuildInputs = [ installShellFiles ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installShellCompletion --bash --name googler.bash auto-completion/bash/googler-completion.bash
    installShellCompletion --fish auto-completion/fish/googler.fish
    installShellCompletion --zsh auto-completion/zsh/_googler
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/jarun/googler";
    description = "Google Search, Google Site Search, Google News from the terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ koral filalex77 ];
    platforms = python.meta.platforms;
  };
}
