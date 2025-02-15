{ lib, stdenv, fetchFromGitHub, python, installShellFiles, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "googler";
  version = "unstable-2024-01-05";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = pname;
    rev = "f55837974ae0566acd8125f59f5948be20e03b41";
    sha256 = "sha256-kvN4i9faD82NL6e20tfIedjQsDburlLFYawQMZDmhCA=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/raffaelewylde/googler/commit/b974abc0903e7832b1d392cf26c46d04f6b36a63.patch";
      sha256 = "sha256-Q2GUjADHu2hHUWdibPGf4kgj5z3G5RISXHP2DVRO32U=";
    })
  ];

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
    maintainers = with maintainers; [ koral Br1ght0ne ];
    platforms = python.meta.platforms;
    mainProgram = "googler";
  };
}
