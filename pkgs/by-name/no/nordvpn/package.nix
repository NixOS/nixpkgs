{
  callPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  symlinkJoin,
  _experimental-update-script-combinators,
}:
let
  version = "6.0.1";

  common = {
    inherit version;

    src = fetchFromGitHub {
      owner = "NordSecurity";
      repo = "nordvpn-linux";
      tag = version;
      hash = "sha256-FI65+ZrsTYAXYoK5HYFWjyGXZZaajC+HCtROtZno5CM=";
    };

    # rec so that changelog can reference homepage
    meta = rec {
      homepage = "https://github.com/NordSecurity/nordvpn-linux";
      changelog = "${homepage}/releases/tag/${version}";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        different-error
        novalkun
      ];
      platforms = lib.platforms.linux;
    };

    desktopItemArgs = {
      categories = [ "Network" ];
      genericName = "VPN Client";
      icon = "nordvpn";
      type = "Application";
    };
  };
in
symlinkJoin {
  pname = "nordvpn";
  inherit version;
  inherit (common) src;

  strictDeps = true;
  __structuredAttrs = true;

  paths = [
    (callPackage ./cli.nix common)
    (callPackage ./gui.nix common)
  ];

  passthru = {
    cli = callPackage ./cli.nix common;
    gui = callPackage ./gui.nix common;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script {
        extraArgs = [
          "--subpackage"
          "cli"
          "--subpackage"
          "gui"
        ];
      })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "nordvpn.gui.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
    ];
  };

  meta = common.meta // {
    description = "NordVPN client and GUI for Linux";
    longDescription = ''
      NordVPN CLI and GUI applications for Linux.
      This package currently does not support meshnet.
      Additionally, if `networking.firewall.enable = true;`,
      then also set `networking.firewall.checkReversePath = "loose";`.
      The closed-source nordwhisper protocol is also not supported.
    '';
  };
}
