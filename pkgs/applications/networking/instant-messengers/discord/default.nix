{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions = if stdenv.isLinux then {
<<<<<<< HEAD
    stable = "0.0.29";
    ptb = "0.0.45";
    canary = "0.0.166";
    development = "0.0.232";
=======
    stable = "0.0.27";
    ptb = "0.0.42";
    canary = "0.0.151";
    development = "0.0.216";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  } else {
    stable = "0.0.273";
    ptb = "0.0.59";
    canary = "0.0.283";
    development = "0.0.8778";
  };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
<<<<<<< HEAD
        sha256 = "sha256-3vjOvkqMD7qKX2zRUbKrw5gHtE/v8WfH557rtagWIWc=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        sha256 = "cN70ZYl9hxWU5FSCpDbpOuR2Wsz6XtPSDoXOTvcCe7g=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        sha256 = "sha256-bUbJpaHUf0ALJ1+4ACcVz0kpZpoXi0S4QO5yLiUZSgs=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        sha256 = "sha256-AsHdQvDLzflhuYO8V4R+2zjQYpRo+aPa8HYXc3taayY=";
=======
        sha256 = "sha256-6fHaiPBcv7TQVh+TatIEYXZ/LwPmnCmU/QWXKFgUR7U=";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        sha256 = "ZAMyAqyFEBJeTUqQzr5wK+BOFGURqhoHL8w2hJvL0vI=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        sha256 = "sha256-ZN+lEGtSajgYsyMoGRmyTZCpUGVmb9LKgVv89NA4m7U=";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        sha256 = "sha256-lQnIQC7Wek7OYDzZvLIJfb8I4oATD8pSB+mjQMPyqYQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        sha256 = "1vz2g83gz9ks9mxwx7gl7kys2xaw8ksnywwadrpsbj999fzlyyal";
      };
      ptb = fetchurl {
        url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        sha256 = "sha256-LS7KExVXkOv8O/GrisPMbBxg/pwoDXIOo1dK9wk1yB8=";
      };
      canary = fetchurl {
        url = "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        sha256 = "0mqpk1szp46mih95x42ld32rrspc6jx1j7qdaxf01whzb3d4pi9l";
      };
      development = fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        sha256 = "sha256-K4rlShYhmsjT2QHjb6+IbCXJFK+9REIx/gW68bcVSVc=";
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
<<<<<<< HEAD
    maintainers = with maintainers; [ MP2E Scrumplex artturin infinidoge jopejoe1 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "discord";
=======
    maintainers = with maintainers; [ MP2E artturin infinidoge jopejoe1 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
