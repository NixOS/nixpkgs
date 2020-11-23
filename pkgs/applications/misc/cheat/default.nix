{ stdenv, fetchFromGitHub
, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "cheat";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    sha256 = "0mraraby0s213ay2ahqsdvnyg76awbqllrkkx17mrx9z3ykba62d";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/cheat.1
    installShellCompletion scripts/cheat.{bash,fish,zsh}
  '';

  vendorSha256 = null;

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
  };
}
