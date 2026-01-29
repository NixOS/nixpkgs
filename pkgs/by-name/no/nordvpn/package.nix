{
  callPackage,
  fetchFromGitHub,
  lib,
  symlinkJoin,
}:
let
  version = "4.3.1";

  commonArgs = {
    myVersion = version;

    mySrc = fetchFromGitHub {
      owner = "NordSecurity";
      repo = "nordvpn-linux";
      tag = version;
      hash = "sha256-o9+9IiXV2CS/Zj3bDg8EJn/UidwA6Fwn4ySFbwyCp60=";
    };

    myMeta = rec {
      homepage = "https://github.com/nordsecurity/nordvpn-linux";
      changelog = "${homepage}/blob/main/contrib/changelog/prod/${version}.md";
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

  # define these here to override in corresponding nixos module definition.
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
      Contributions welcome!
    '';
  };
}
