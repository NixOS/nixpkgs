{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions =
    if stdenv.isLinux then {
      stable = "0.0.65";
      ptb = "0.0.101";
      canary = "0.0.475";
      development = "0.0.24";
    } else {
      stable = "0.0.316";
      ptb = "0.0.130";
      canary = "0.0.583";
      development = "0.0.46";
    };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-kzYLZcjuG7k8RSjc5ooDlMKaAlMHvm0yCl5Krnhqq8A=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-JesxPoYybVLVwTrDwG2kO6Pikq7qvn7CO8j+24dwjBc=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-suVIDCZhI6DwUVizBmTm104Clr6pH/olAIbOMNzFNss=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-rSlGL2BwtUxLJltSD2Ms94qmZ4kuX5i9jFqyYC30jyQ=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-ZJ2ybvKGGCm8CZhwGxmLXZWNUD1eAyg17zD/sBwViB4=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-mLfeMx5dQNpoLUyoOSCj8XtNxWjsBpVWdFv1obtHJak=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-eIjkXOW07sR26iBttT0mGDxNnpLFKlVJtzSAtFcicBg=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-nMihtf/xLIxwqAVrF1BSRewdS2WThx0LZ5HZUI+OzM0=";
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
