{ lib, fetchFromGitHub
, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "cheat";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    sha256 = "sha256-GUU6VWfTmNS6ny12HnMr3uQmS7HI86Oupcmqx0MVAvE=";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/cheat.1
    installShellCompletion scripts/cheat.{bash,fish,zsh}
  '';

  vendorHash = null;

  doCheck = false;

  meta = with lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
    mainProgram = "cheat";
  };
}
