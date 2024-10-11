{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions =
    if stdenv.hostPlatform.isLinux then {
      stable = "0.0.71";
      ptb = "0.0.110";
      canary = "0.0.502";
      development = "0.0.30";
    } else {
      stable = "0.0.322";
      ptb = "0.0.140";
      canary = "0.0.611";
      development = "0.0.53";
    };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-PMcavgUhL8c1YFaWsooZObDa7APMqCD1IaysED5fWac=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-NV/0YKn1rG54Zkc9qAmpeb+4YbKjxhjTCdPOd84Lcc8=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-2DE7p3eT/mVGC+ejnTcTEhF7sEWyhfUfzj0gYTh+6Dw=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-HxMJQd5fM1VNfrBey4SbnnBkFQYZgbxg4YTy6FIC9Ps=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-RLAdcCcRrUtDSdaj/RdVLJGvufpIjZoMAKxp0Jyu17A=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-VGhvykujfzI7jwXE+lHTzqT0t08GaON6gCuf13po7wY=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-QC8RANqoyMAGKjTF0NNhz7wMt65D5LI1xYtd++dHXC4=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-DhY8s7Mhzos0ygB/WuoE07WK6hoIh/FcETeIsffw+e0=";
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
        stable = {
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
