{ branch ? "stable", pkgs }:

let
  inherit (pkgs) callPackage fetchurl;
in {
  stable = callPackage ./base.nix {
    pname = "discord";
    binaryName = "Discord";
    desktopName = "Discord";
    version = "0.0.9";
    src = fetchurl {
      url = "https://dl.discordapp.net/apps/linux/0.0.9/discord-0.0.9.tar.gz";
      sha256 = "1i0f8id10rh2fx381hx151qckvvh8hbznfsfav8w0dfbd1bransf";
    };
  };
  ptb = callPackage ./base.nix {
    pname = "discord-ptb";
    binaryName = "DiscordPTB";
    desktopName = "Discord PTB";
    version = "0.0.16";
    src = fetchurl {
      url = "https://dl-ptb.discordapp.net/apps/linux/0.0.16/discord-ptb-0.0.16.tar.gz";
      sha256 = "1ia94xvzygim9rx1sjnnss518ggw0i20mhp9pby33q70ha35n0aq";
    };
  };
  canary = callPackage ./base.nix {
    pname = "discord-canary";
    binaryName = "DiscordCanary";
    desktopName = "Discord Canary";
    version = "0.0.95";
    src = fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/0.0.95/discord-canary-0.0.95.tar.gz";
      sha256 = "06qhm73kc88pq0lgbi7qjy4gx9ighkmx128fdm1dpzfv62fjdasw";
    };
  };
}.${branch}
