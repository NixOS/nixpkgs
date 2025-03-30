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
        stable = "0.0.89";
        ptb = "0.0.136";
        canary = "0.0.621";
        development = "0.0.73";
      }
    else
      {
        stable = "0.0.342";
        ptb = "0.0.167";
        canary = "0.0.729";
        development = "0.0.84";
      };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-74M2SAJLS8u37m2bEo/Yblq822EbWWZfpLf5emvTusE=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-7MAipSoToCTJa+QFUty88V8SXXgJJdoQfH21yCGOKvA=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-Jz7YIH107n89N/wQfhs9QfEqWCYO+BtjHrgSvk7xG+o=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-zd8KpyBTdj+7jb1kRY99a48thdCRq3RNSC8oWKAQJXg=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-4Z/Up7KRRTaWEMUjVPi/CXbdeoEka72ZG6r3AeVmVjg=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-7ueaVb7SrD/GOVCPvf/91CaTw2jtiV/XrIsTu2RHdOM=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-yP/eW1fKmZ8I5BtFOOKmmYjXlSF44HlcM8LpPNHA+Pc=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-8qgWvcfWTL1FXSy5CeihpMxS3Ysa79ZFAlG1rAcoyUo=";
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
