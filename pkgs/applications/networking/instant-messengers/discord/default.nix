{ branch ? "stable", pkgs }:
let
  inherit (pkgs) callPackage fetchurl;
in {
  stable = callPackage ./base.nix rec {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.16";
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
      sha256 = "UTVKjs/i7C/m8141bXBsakQRFd/c//EmqqhKhkr1OOk=";
    };
  };
  ptb = callPackage ./base.nix rec {
    pname = "discord-ptb";
    binaryName = "DiscordPTB";
    desktopName = "Discord PTB";
    version = "0.0.26";
    src = fetchurl {
      url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
      sha256 = "1rlj76yhxjwwfmdln3azjr69hvfx1bjqdg9jhdn4fp6mlirkrcq4";
    };
  };
  canary = callPackage ./base.nix rec {
    pname = "discord-canary";
    binaryName = "DiscordCanary";
    desktopName = "Discord Canary";
    version = "0.0.132";
    src = fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "1jjbd9qllgcdpnfxg5alxpwl050vzg13rh17n638wha0vv4mjhyv";
    };
  };
}.${branch}
