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
    version = "0.0.131";
    src = fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "087rzyivk0grhc73v7ldxxghks0n16ifrvpmk95vzaw99l9xv0v5";
    };
  };
}.${branch}
