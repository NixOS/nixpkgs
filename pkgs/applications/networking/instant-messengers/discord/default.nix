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
        canary = "0.0.541";
        development = "0.0.54";
      }
    else
      {
        stable = "0.0.329";
        ptb = "0.0.151";
        canary = "0.0.653";
        development = "0.0.68";
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
        hash = "sha256-upT12C23Vkm+BZycKAufRzM5YHizpZJtEaJjHGzYtv4=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-3Qhysb7QFE7W4nqAHffgz9hbud6n6PGcGN6xGBmD6ow=";
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
        hash = "sha256-uBnVz+d5Mp3fjICQQ/SZgFmkXVQGprf7VvUxv0hy00o=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-5sUkGN9ucyYArGkfbGBdJokoqpHKBrkwxH055LpMlrs=";
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
