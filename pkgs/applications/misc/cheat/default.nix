{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cheat";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "chrisallenlane";
    repo = "cheat";
    rev = version;
    sha256 = "0i5j85ciimk14kndb81qxny1ksr57sr9xdvjn7x1ibc7h6pikjn5";
  };

  subPackages = [ "cmd/cheat" ];

  modSha256 = "1v9hvxygwvqma2j5yz7r95g34xpwb0n29hm39i89vgmvl3hy67s0";

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    homepage = "https://github.com/chrisallenlane/cheat";
  };
}
