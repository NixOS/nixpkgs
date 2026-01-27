{
  callPackage,
  fetchFromGitHub,
  lib,
  symlinkJoin,
}:
let
  commonArgs = rec {
    myVersion = "4.3.1";

    mySrc = fetchFromGitHub {
      owner = "NordSecurity";
      repo = "nordvpn-linux";
      tag = myVersion;
      hash = "sha256-o9+9IiXV2CS/Zj3bDg8EJn/UidwA6Fwn4ySFbwyCp60=";
    };

    myMeta = rec {
      homepage = "https://github.com/${mySrc.owner}/${mySrc.repo}";
      changelog = "${homepage}/releases/tag/${myVersion}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ different-error ];
      platforms = lib.platforms.linux;
    };

    myDesktopItemArgs = {
      categories = [ "Network" ];
      genericName = "a vpn provider";
      icon = "nordvpn";
      type = "Application";
    };
  };
in
symlinkJoin rec {
  pname = "nordvpn";
  version = commonArgs.myVersion;

  # call packages here to override in corresponding module definition.
  cli = callPackage ./cli.nix commonArgs;
  gui = callPackage ./gui.nix commonArgs;

  paths = [
    cli
    gui
  ];

  meta = commonArgs.myMeta // {
    description = "NordVPN cli and gui applications for Linux.";
    longDescription = ''
      NordVPN cli and gui applications for Linux.
      This package currently does not support meshnet.
      Additionally, if `networking.firewall.enable = true;`,
      then also set `networking.firewall.checkReversePath = "loose";`.
      The closed-source nordwhisper protocol is also not supported.
      Contributions welcome!

      Run `nordvpnd` with root privileges:
      ```bash
      sudo nordvpnd
      sudo chown $USER:$USER /run/nordvpn/nordvpnd.sock
      ```

      Some common cli commands:
      ```bash
      nordvpn login
      nordvpn set technology nordlynx
      nordvpn connect
      ```

      To launch the gui:
      ```bash
      nordvpn-gui
      ```
    '';
  };
}
