{ lib, fetchFromGitHub
, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "cheat";
  version = "4.2.5";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = "refs/tags/${version}";
    sha256 = "sha256-WCNjQ5bfC7xjBt74y//KkMQFFxuP293MAADpp5MxtSA=";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/cheat.1
    installShellCompletion scripts/cheat.{bash,fish,zsh}
  '';

  vendorSha256 = null;

  doCheck = false;

  meta = with lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
  };
}
