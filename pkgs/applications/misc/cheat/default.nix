{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cheat";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    sha256 = "062dlc54x9qwb3hsxp20h94dpwsa1nzpjln9cqmvwjhvp434l97r";
  };

  subPackages = [ "cmd/cheat" ];

  modSha256 = "1is19qca5wgzya332rmpk862nnivxzgxchkllv629f5fwwdvdgmg";

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    inherit (src.meta) homepage;
  };
}
