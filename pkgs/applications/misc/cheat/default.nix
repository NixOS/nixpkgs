{ stdenv, fetchFromGitHub
, buildGoModule, installShellFiles }:

buildGoModule rec {
  pname = "cheat";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    sha256 = "0jbqflkcfdrinx1lk45klm8ml0n4cgp43nzls1376cd3hfayby1y";
  };

  subPackages = [ "cmd/cheat" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion scripts/cheat.{bash,fish,zsh}
  '';

  modSha256 = "1is19qca5wgzya332rmpk862nnivxzgxchkllv629f5fwwdvdgmg";

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
  };
}
