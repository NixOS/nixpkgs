{ lib, callPackage }:

callPackage ../mk-weechat-script.nix {} {
  pname = "autojoin";
  version = "0.3.1";

  filename = "autojoin.py";

  repoRev = "e19ddd3558ac74f695bacf420a6efddc5e3c54bd";
  repoSha256 = "044zciaf81bi4y69ayji34i9ncqbxk9drijsiz2qa8lxxmp7qqac";

  meta = with lib; {
    homepage = "https://weechat.org/scripts/source/autojoin.py.html/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bdesham ];
    description = "A WeeChat script to automatically rejoin the current channels";
  };
}
