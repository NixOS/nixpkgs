{ stdenv, fetchFromGitHub, python3, installShellFiles }:

stdenv.mkDerivation rec {
  version = "1.8";
  pname = "ddgr";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "ddgr";
    rev = "v${version}";
    sha256 = "1cyaindcg2vc3ij0p6b35inr01c6ys04izxsn1h70ixhsz46qg8z";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ python3 ];

  makeFlags = [ "PREFIX=$(out)" ];

  # Version 1.8 was released as 1.7
  postPatch = ''
    substituteInPlace ddgr --replace "_VERSION_ = '1.7'" "_VERSION_ = '${version}'"
  '';

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
