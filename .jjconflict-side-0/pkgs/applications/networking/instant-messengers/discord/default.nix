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
        stable = "0.0.77";
        ptb = "0.0.121";
        canary = "0.0.538";
        development = "0.0.53";
      }
    else
      {
        stable = "0.0.329";
        ptb = "0.0.151";
        canary = "0.0.650";
        development = "0.0.67";
      };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-Mm6kdwBsIOOkU1cNgfx4EZq/xeZPwUb2keKBkYv52hQ=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-Zaf6Pg6xeSyiIFJMlT+VkE/sXJULSqGzGHmK5MpBuhg=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-RYwHDoPj0TsraI/7dNpngCiB6Fiyhi5ec/iCZD7YMoQ=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-4FxdZsVTQTr5yzuzV6IZYZ6qk7sa9WZ27zCtVA1/uOg=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-LIB+MwGm15TE5xB1yNPY61RmYVUJo7+i94qwDag6uHY=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-R8R3r2i/+ru+82OBGBmF+Kn502RK/64VwtbdRVSwj0g=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-QFeUeuJMZ9r7lqFhE51jQfpSw5v4+MgUoO2HEcKF4mI=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-nyOQhSjlARvIjFc3uDi7IFtKxxIpO/V6M1eIg56dMdU=";
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
      donteatoreo
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
