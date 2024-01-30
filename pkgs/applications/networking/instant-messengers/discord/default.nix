{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions =
    if stdenv.isLinux then {
      stable = "0.0.42";
      ptb = "0.0.66";
      canary = "0.0.257";
      development = "0.0.11";
    } else {
      stable = "0.0.292";
      ptb = "0.0.96";
      canary = "0.0.401";
      development = "0.0.27";
    };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-7can15JhBc6OJAWZMk8uEdt/D1orCKG1MN1WBdTZrI0=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-3ocygqp8eiF3n/BVlTp1T1CRsGj56MGp1yPsvBE7/H4=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-2AUCTWKEB4cy2tFfnJMn8Ywz1B8a3H6yhkVIcB0fLME=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-bN77yfmz/W3ohSKHV4pwnKEET6yi3p29ZfqH1BvFqXs=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-1BKMIWSb7+oQ+B80GUCslKn5VNdM0hPTNyZkI/RsxhM=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-dG0Wcx8X2+kzrpacFZmMCXfLsuLOLbDK4qVLAMzd4RA=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-fz/LDQJ/B8luN6Ffobp82hnycBOLg9Kdi0kXLGltCDc=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-MRCBPe98Czm1OG2l3c1GAW4a27fV8XMtQ9pPIJMgqzA=";
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
