{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.2";
  pname = "ddgr";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "ddgr";
    rev = "v${finalAttrs.version}";
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

  meta = {
    homepage = "https://github.com/jarun/ddgr";
    description = "Search DuckDuckGo from the terminal";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      ceedubs
      markus1189
    ];
    platforms = python3.meta.platforms;
    mainProgram = "ddgr";
  };
})
