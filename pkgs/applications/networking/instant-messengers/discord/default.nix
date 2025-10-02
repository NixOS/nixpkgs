{
  branch ? "stable",
  callPackage,
  fetchurl,
  lib,
  stdenv,
  writeScript,
  _experimental-update-script-combinators,
}:
let
  versions =
    if stdenv.hostPlatform.isLinux then
      {
        stable = "0.0.111";
        ptb = "0.0.161";
        canary = "0.0.761";
        development = "0.0.89";
      }
    else
      {
        stable = "0.0.362";
        ptb = "0.0.192";
        canary = "0.0.867";
        development = "0.0.100";
      };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-o4U6i223Agtbt1N9v0GO/Ivx68OQcX/N3mHXUX2gruA=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-pDWOnj8tQK9runi/QzcvEFbNGCwAb/gISM9LrLoTzxM=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-L3MIcrz/xj8zOb2QVXBrBCHGt4BdHhjwKpPZ4iClQYQ=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-ZMsBR0LAISrM3dib8fehW/eZGkwSCinQF60jJG76O7M=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-DHe0WwJOB3mm1HbQwEOJ9NWqxzhOBQynhjJXYSNvA/k=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-AZ9enKJf6WZLELFLKrzeyAR/Q/pzD8SGvCPcInS8vsk=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-67B2wZRZEOKutMPsrRlc96UZWShYLAgwOoF2/QzBgzE=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-PknNHr9txxp3+nO7FgHH7n04qx6p6Jzbs92/Hcfh13Y=";
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

  updateScript = _experimental-update-script-combinators.sequence (
    let
      update =
        attr:
        writeScript "update-${attr}" ''
          nix-shell maintainers/scripts/update.nix \
            --argstr commit true \
            --argstr skip-prompt true \
            --arg get-script 'pkg: pkg.actualUpdateScript or null' \
            --argstr package "${attr}"
        '';

      packages = [
        "discord"
        "discord-ptb"
        "discord-canary"
        "discord-development"
        "pkgsCross.aarch64-darwin.discord"
        "pkgsCross.aarch64-darwin.discord-ptb"
        "pkgsCross.aarch64-darwin.discord-canary"
        "pkgsCross.aarch64-darwin.discord-development"
      ];
    in
    (
      (lib.map (pkg: update pkg) packages)
      ++ [
        (writeScript "discord-commit-squash" ''
          commit_amount="$(git rev-list --count master..HEAD)"
          if [[ $commit_amount -eq 0 ]]; then
              echo "No updates"
              exit 0
          fi

          commit_msgs="$(git log -n $commit_amount --reverse --pretty=format:'%s%n%n%b' | sed '/^$/N;/^\n$/D')"

          git reset --soft HEAD~"$commit_amount"

          git commit -m "discord: Update all" -m "$commit_msgs"
        '')
      ]
    )
  );

  packages = (
    builtins.mapAttrs
      (
        _: value:
        callPackage package (
          value
          // {
            inherit
              src
              version
              branch
              updateScript
              ;
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
