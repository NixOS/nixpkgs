{
  callPackage,
  fetchurl,
  lib,
  stdenv,
  discord,
  discord-ptb,
  discord-canary,
  discord-development,
}:
let
  variants = rec {
    x86_64-linux = {
      discord = rec {
        version = "0.0.111";

        src = fetchurl {
          url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
          hash = "sha256-o4U6i223Agtbt1N9v0GO/Ivx68OQcX/N3mHXUX2gruA=";
        };

        branch = "stable";
        binaryName = desktopName;
        desktopName = "Discord";
        self = discord;
      };
      discord-ptb = rec {
        version = "0.0.161";

        src = fetchurl {
          url = "https://ptb.dl2.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
          hash = "sha256-pDWOnj8tQK9runi/QzcvEFbNGCwAb/gISM9LrLoTzxM=";
        };

        branch = "ptb";
        binaryName = "DiscordPTB";
        desktopName = "Discord PTB";
        self = discord-ptb;
      };
      discord-canary = rec {
        version = "0.0.761";

        src = fetchurl {
          url = "https://canary.dl2.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
          hash = "sha256-L3MIcrz/xj8zOb2QVXBrBCHGt4BdHhjwKpPZ4iClQYQ=";
        };

        branch = "canary";
        binaryName = "DiscordCanary";
        desktopName = "Discord Canary";
        self = discord-canary;
      };
      discord-development = rec {
        version = "0.0.89";

        src = fetchurl {
          url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
          hash = "sha256-ZMsBR0LAISrM3dib8fehW/eZGkwSCinQF60jJG76O7M=";
        };

        branch = "development";
        binaryName = "DiscordDevelopment";
        desktopName = "Discord Development";
        self = discord-development;
      };
    };
    x86_64-darwin = {
      discord = rec {
        version = "0.0.362";

        src = fetchurl {
          url = "https://stable.dl2.discordapp.net/apps/osx/${version}/Discord.dmg";
          hash = "sha256-DHe0WwJOB3mm1HbQwEOJ9NWqxzhOBQynhjJXYSNvA/k=";
        };

        branch = "stable";
        binaryName = desktopName;
        desktopName = "Discord";
        self = discord;
      };
      discord-ptb = rec {
        version = "0.0.192";

        src = fetchurl {
          url = "https://ptb.dl2.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
          hash = "sha256-AZ9enKJf6WZLELFLKrzeyAR/Q/pzD8SGvCPcInS8vsk=";
        };

        branch = "ptb";
        binaryName = desktopName;
        desktopName = "Discord PTB";
        self = discord-ptb;
      };
      discord-canary = rec {
        version = "0.0.867";

        src = fetchurl {
          url = "https://canary.dl2.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
          hash = "sha256-67B2wZRZEOKutMPsrRlc96UZWShYLAgwOoF2/QzBgzE=";
        };

        branch = "canary";
        binaryName = desktopName;
        desktopName = "Discord Canary";
        self = discord-canary;
      };
      discord-development = rec {
        version = "0.0.100";

        src = fetchurl {
          url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
          hash = "sha256-PknNHr9txxp3+nO7FgHH7n04qx6p6Jzbs92/Hcfh13Y=";
        };

        branch = "development";
        binaryName = desktopName;
        desktopName = "Discord Development";
        self = discord-development;
      };
    };

    aarch64-darwin = x86_64-darwin;
    default = x86_64-linux; # Used for unsupported platforms, so we can return *something* there.
  };

  meta = {
    description = "All-in-one cross-platform voice and text chat for gamers";
    downloadPage = "https://discordapp.com/download";
    homepage = "https://discordapp.com/";
    license = lib.licenses.unfree;
    mainProgram = "discord";
    maintainers = with lib.maintainers; [
      artturin
      FlameFlag
      infinidoge
      jopejoe1
      Scrumplex
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
  package = if stdenv.hostPlatform.isLinux then ./linux.nix else ./darwin.nix;
in
lib.genAttrs [ "discord" "discord-ptb" "discord-canary" "discord-development" ] (
  pname:
  let
    args = (variants.${stdenv.hostPlatform.system} or variants.default).${pname};
  in
  callPackage package (
    args
    // {
      inherit pname;

      meta = meta // {
        mainProgram = args.binaryName;
      };
    }
  )
)
