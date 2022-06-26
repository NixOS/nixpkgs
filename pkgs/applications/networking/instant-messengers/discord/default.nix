{ branch ? "stable", callPackage, fetchurl, lib, stdenv }:
let
  versions = if stdenv.isLinux then {
    stable = "0.0.18";
    ptb = "0.0.29";
    canary = "0.0.135";
    development = "0.0.202";
  } else {
    stable = "0.0.264";
    ptb = "0.0.59";
    canary = "0.0.283";
    development = "0.0.8759";
  };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url =
          "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        sha256 = "1hl01rf3l6kblx5v7rwnwms30iz8zw6dwlkjsx2f1iipljgkh5q4";
      };
      ptb = fetchurl {
        url =
          "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        sha256 = "d78NnQZ3MkLje8mHrI6noH2iD2oEvSJ3cDnsmzQsUYc=";
      };
      canary = fetchurl {
        url =
          "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        sha256 = "sha256-dmG+3BWS1BMHHQAv4fsXuObVeAJBeD+TqnyQz69AMac=";
      };
      development = fetchurl {
        url =
          "https://dl-development.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        sha256 = "sha256-+OqIhjGr6y5xtFE5MpVlPM/Y7KCU66HH93/OIxgdq3k=";
      };
    };

    aarch64-darwin = {
      ptb = fetchurl {
        url =
          "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        sha256 = "sha256-LS7KExVXkOv8O/GrisPMbBxg/pwoDXIOo1dK9wk1yB8=";
      };
      canary = fetchurl {
        url =
          "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        sha256 = "0mqpk1szp46mih95x42ld32rrspc6jx1j7qdaxf01whzb3d4pi9l";
      };
      development = fetchurl {
        url =
          "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        sha256 = "sha256-F/OR0l1Rh/YQaR5V/kmSLNQPwvFeWj/NfgY8fUYg9fA=";
      };
    };

    # Stable does not (yet) provide aarch64-darwin support. PTB, Canary, and Development do.
    x86_64-darwin = aarch64-darwin
      // {
        stable = fetchurl {
          url =
            "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
          sha256 = "1jvlxmbfqhslsr16prsgbki77kq7i3ipbkbn67pnwlnis40y9s7p";
        };
      };
  };

  src = srcs.${stdenv.hostPlatform.system}.${branch};

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discordapp.com/";
    downloadPage = "https://discordapp.com/download";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ ldesgoui MP2E devins2518 ivar ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ]
      ++ lib.optionals (branch != "stable") [ "aarch64-darwin" ];
  };

  package = if stdenv.isLinux then ./linux.nix else ./darwin.nix;

  openasar = callPackage ./openasar.nix { };

  packages = (builtins.mapAttrs
    (_: value: callPackage package
      (value // {
        inherit src version openasar;
        meta = meta // { mainProgram = value.binaryName; };
      })
    )
    {
      stable = {
        pname = "discord";
        binaryName = "Discord";
        desktopName = "Discord";
      };
      ptb = {
        pname = "discord-ptb";
        binaryName = "DiscordPTB";
        desktopName = "Discord PTB";
      };
      canary = {
        pname = "discord-canary";
        binaryName = "DiscordCanary";
        desktopName = "Discord Canary";
      };
      development = {
        pname = "discord-development";
        binaryName = "DiscordDevelopment";
        desktopName = "Discord Development";
      };
    }
  );
in packages.${branch}
