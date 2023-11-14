{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions = if stdenv.isLinux then {
    stable = "0.0.33";
    ptb = "0.0.53";
    canary = "0.0.173";
    development = "0.0.1";
  } else {
    stable = "0.0.282";
    ptb = "0.0.84";
    canary = "0.0.329";
    development = "0.0.2";
  };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-UVgufPNIS7fa3VDzjCWwgK3xxmqNivq461qWLgirClc=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-g2NhwkfNi5Yf+n9vHq/MJ0kylPF3MPocgF/zYfCvoZM=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-YFjGUAaZMy1JhtKhAqLbfYTKQSgS9TKWqR078cERNUI=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-ogLOZZ9pTXB01TqdnmdORIzZ8GbGzskUzbG4E68gZwY=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-3WeC+4W9+tpXNXqETorQfnE1HZWCqRkBqW0JM7whRCw=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-e2gvjXUw0Yx8UY6utg1SdX8/buewuVYPl5I8fS3QtrI=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-B4LPFts+sx8GpZp9iRbwapUYrK4c9unH+mAoODGqDgU=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-iMw61dXtThXvz2GnZiM4+tURMRfXhrN/ze1RTBL6zy8=";
      };
    };
    aarch64-darwin = x86_64-darwin;
  };
  src = srcs.${stdenv.hostPlatform.system}.${branch};

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discordapp.com/";
    downloadPage = "https://discordapp.com/download";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ MP2E Scrumplex artturin infinidoge jopejoe1 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "discord";
  };
  package =
    if stdenv.isLinux
    then ./linux.nix
    else ./darwin.nix;

  openasar = callPackage ./openasar.nix { };

  packages = (
    builtins.mapAttrs
      (_: value:
        callPackage package (value
          // {
          inherit src version openasar branch;
          meta = meta // { mainProgram = value.binaryName; };
        }))
      {
        stable = rec {
          pname = "discord";
          binaryName = "Discord";
          desktopName = "Discord";
        };
        ptb = rec {
          pname = "discord-ptb";
          binaryName = if stdenv.isLinux then "DiscordPTB" else desktopName;
          desktopName = "Discord PTB";
        };
        canary = rec {
          pname = "discord-canary";
          binaryName = if stdenv.isLinux then "DiscordCanary" else desktopName;
          desktopName = "Discord Canary";
        };
        development = rec {
          pname = "discord-development";
          binaryName = if stdenv.isLinux then "DiscordDevelopment" else desktopName;
          desktopName = "Discord Development";
        };
      }
  );
in
packages.${branch}
