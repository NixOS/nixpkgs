{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions =
    if stdenv.isLinux then {
      stable = "0.0.50";
      ptb = "0.0.80";
      canary = "0.0.357";
      development = "0.0.17";
    } else {
      stable = "0.0.301";
      ptb = "0.0.109";
      canary = "0.0.477";
      development = "0.0.39";
    };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-6VXdVLk7Z8NGQMiSdgBRd8NIueUktkId6BXYKNABb+4=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-y/ntnHIYcY35Jszh0PrFy395eJ5dBWwLNpzHMoSZuNA=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-sDwC5kPzAfvQmsrq6M/GPFtUaT9pNAEB4uGI5Mn3oXs=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-AmbaMVi/or+9QLuQO5u5btgKeKdrfo7bzZgGLILwgqo=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-h7C1wCKtUGcMFUhoKVdD7Vq9TGUaXfmjlVhwmRdhqYw=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-xxLnzELuI0X2r/weP1K2Bb51uRh1JjR72p7cXzy12Kc=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-xEDtEtZNhOTtz+zRLLQBSeLbntlVAVQsocAGyAaVePM=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-nZV9LK3eGpXK/2wQKJBn3K2Ud6uBk8aammkeE00rWx0=";
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
