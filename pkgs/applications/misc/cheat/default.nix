{ lib, fetchFromGitHub
, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "cheat";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    hash = "sha256-n6i7n5skACra4tm+kGM+jk6UwP1Wcb1GuJdiYc95Emg=";
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
    mainProgram = "cheat";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
  };
}
