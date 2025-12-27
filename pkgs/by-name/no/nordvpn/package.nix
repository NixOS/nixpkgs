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
    myMeta = {
      homepage = "https://github.com/nordsecurity/nordvpn-linux";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [ different-error ];
      platforms = lib.platforms.linux;
    };
  };

  cli = callPackage ./cli.nix commonArgs;

  gui = callPackage ./gui.nix commonArgs;
in
symlinkJoin {
  inherit cli gui; # inherit packages here to override in module

  pname = "nordvpn";
  version = commonArgs.myVersion;

  paths = [
    cli
    gui
  ];

  meta = commonArgs.myMeta // {
    description = "NordVPN cli and gui application for Linux";
    longDescription = ''
      NordVPN cli and gui application for Linux.
      This package currently does not support meshnet.
      Additionally, if `networking.firewall.enable = true;`,
      then also set `networking.firewall.checkReversePath = "loose";`.
      Contributions welcome!
    '';
  };
}
