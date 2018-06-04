{ pkgs, options, lib, ... }: with lib; {
  imports = [
    ./nixos/modules/profiles/minimal.nix
  ];
  environment.systemPackages = with pkgs; [
    vim
    weechat
  ];
  services.nixosManual.enable = true;
  documentation.enable = true;
  i18n.consoleUseXkbConfig = true;
  services.xserver.xkbVariant = "dvp";
  users.users.root.password = "root";
  services.znc = {
    enable = true;
    mutable = false;

    confOptions.passBlock = ''
      <Pass password>
        Method = sha256
        Hash = e2ce303c7ea75c571d80d8540a8699b46535be6a085be3414947d638e48d9e93
        Salt = l5Xryew4g*!oa(ECfX2o
      </Pass>
    '';
    confOptions.networks = {
      freenode = {
        server = "chat.freenode.net";
        port = 6697;
        useSSL = true;
        modules = [ "simple_away" ];
      };
    };
  };
}
