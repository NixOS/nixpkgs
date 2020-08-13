{ stdenv, fetchFromGitHub, python3, installShellFiles }:

stdenv.mkDerivation rec {
  version = "1.9";
  pname = "ddgr";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "ddgr";
    rev = "v${version}";
    sha256 = "0qbdq7k0mmvkjp6qzz88n7vf29liqn6y5w4y39ldqdc8hzw5sld7";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ python3 ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installShellCompletion --bash --name ddgr.bash auto-completion/bash/ddgr-completion.bash
    installShellCompletion --fish auto-completion/fish/ddgr.fish
    installShellCompletion --zsh auto-completion/zsh/_ddgr
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/jarun/ddgr";
    description = "Search DuckDuckGo from the terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ceedubs markus1189 ];
    platforms = python3.meta.platforms;
  };
}
