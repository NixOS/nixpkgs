{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  version = "2.2";
  pname = "ddgr";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "ddgr";
    rev = "v${version}";
    sha256 = "sha256-88cCQm3eViy0OwSyCTlnW7uuiFwz2/6Wz45QzxCgXxg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ python3 ];

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installShellCompletion --bash --name ddgr.bash auto-completion/bash/ddgr-completion.bash
    installShellCompletion --fish auto-completion/fish/ddgr.fish
    installShellCompletion --zsh auto-completion/zsh/_ddgr
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/jarun/ddgr";
    description = "Search DuckDuckGo from the terminal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://github.com/jarun/ddgr";
    description = "Search DuckDuckGo from the terminal";
    license = licenses.gpl3;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      ceedubs
      markus1189
    ];
    platforms = python3.meta.platforms;
    mainProgram = "ddgr";
  };
}
