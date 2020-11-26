{ lib, callPackage }:

callPackage ../mk-weechat-script.nix {} {
  pname = "text-item";
  version = "0.9";

  filename = "text_item.py";

  repoRev = "5a87f03a37764cb1d87ab09463b4986cb1b82d8b";
  repoSha256 = "1yqbf59q8fxd44v5hv519si4kr3y3hhd5nvrsay7ljfjqm0rpwp4";

  meta = with lib; {
    homepage = "https://weechat.org/scripts/source/text_item.py.html/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ bdesham ];
    description = "A WeeChat script to add plain-text bar items";
  };
}
