{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions =
    if stdenv.isLinux then {
      stable = "0.0.54";
      ptb = "0.0.85";
      canary = "0.0.402";
      development = "0.0.19";
    } else {
      stable = "0.0.305";
      ptb = "0.0.114";
      canary = "0.0.510";
      development = "0.0.41";
    };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-ruaotzJ+dvqNUV/e4xpJ1rorGiC4Im57BSSiddP8ZF8=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-2RyilxldJX2wqKlEcrp6srj0O7UNHMxySRJD1xBfqMk=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-YE+sHmEkUCHLflSUgf4aotWWdzhbFyzozc3vLcJ96yA=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-RP6SUM4DW3JhddSbJX6Xg8EE4iqCkSOgBL1oa7Zwp/E=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-UEKsweUvtVKXZDrdIYuo3FPSPrnY3ECIilntBs9ZrGU=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-ahCgJ1aSLL7Mhx5Jjkeuqqlis8gqxHbIhQvlbUK2wIU=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-viWOmu1+6tpzNDN/q0kXRMo+rohOP6/L7ke2EeBEADg=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-RiGyca/zjPpENgcq9KnRh5G4YArrUOQeueUdUBgZgjo=";
      };
    };
    aarch64-darwin = x86_64-darwin;
  };
  src = srcs.${stdenv.hostPlatform.system}.${branch} or (throw "${stdenv.hostPlatform.system} not supported on ${branch}");

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discordapp.com/";
    downloadPage = "https://discordapp.com/download";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ Scrumplex artturin infinidoge jopejoe1 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "discord";
  };
  package =
    if stdenv.isLinux
    then ./linux.nix
    else ./darwin.nix;

  packages = (
    builtins.mapAttrs
      (_: value:
        callPackage package (value
          // {
          inherit src version branch;
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
