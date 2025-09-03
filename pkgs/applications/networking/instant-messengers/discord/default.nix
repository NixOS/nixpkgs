{
  branch ? "stable",
  callPackage,
  fetchurl,
  lib,
  stdenv,
}:
let
  versions =
    if stdenv.hostPlatform.isLinux then
      {
        stable = "0.0.107";
        ptb = "0.0.158";
        canary = "0.0.745";
        development = "0.0.84";
      }
    else
      {
        stable = "0.0.356";
        ptb = "0.0.186";
        canary = "0.0.844";
        development = "0.0.97";
      };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-uL923Fc8Io0GUnQjaAl7sRahL6CO/qzNzkqk/oKkZCo=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-LPzdVaXQXmnlD274ESZ2/AceXcoazReA1HemuTcdj1o=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-6vo7vevxzVyZpLWBbTPS94wQU3pQtrMsxc91S02M42M=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-0SmCBi/fl77m5PzI5O38CpAoIzyQc+eRUKLyKVMQ6Dc=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-oATRY8cpdpTZr7iMQ/SIvSbXDxhsCviQQFqytDG9u/c=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-f5qoDpwcp1qBDyD+0QPE7KU6pJLALZPO7auGoo3JJiA=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-i5ffkto9QoMorqsLQSUF9KnSHOK0tEFcPqkhSJ9cV+s=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-BVTQPr3Oox/mTNE7LTJfYuKhI8PlkJlznKiOffqpECs=";
      };
    };
    aarch64-darwin = x86_64-darwin;
  };
  src =
    srcs.${stdenv.hostPlatform.system}.${branch}
      or (throw "${stdenv.hostPlatform.system} not supported on ${branch}");

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

  packages = (
    builtins.mapAttrs
      (
        _: value:
        callPackage package (
          value
          // {
            inherit src version branch;
            meta = meta // {
              mainProgram = value.binaryName;
            };
          }
        )
      )
      {
        stable = {
          pname = "discord";
          binaryName = "Discord";
          desktopName = "Discord";
        };
        ptb = rec {
          pname = "discord-ptb";
          binaryName = if stdenv.hostPlatform.isLinux then "DiscordPTB" else desktopName;
          desktopName = "Discord PTB";
        };
        canary = rec {
          pname = "discord-canary";
          binaryName = if stdenv.hostPlatform.isLinux then "DiscordCanary" else desktopName;
          desktopName = "Discord Canary";
        };
        development = rec {
          pname = "discord-development";
          binaryName = if stdenv.hostPlatform.isLinux then "DiscordDevelopment" else desktopName;
          desktopName = "Discord Development";
        };
      }
  );
in
packages.${branch}
