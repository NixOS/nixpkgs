{
  branch ? "stable",
  callPackage,
  fetchurl,
  lib,
  stdenv,
  writeScript,
}:
let
  versions =
    if stdenv.hostPlatform.isLinux then
      {
        stable = "0.0.101";
        ptb = "0.0.152";
        canary = "0.0.716";
        development = "0.0.83";
      }
    else
      {
        stable = "0.0.353";
        ptb = "0.0.181";
        canary = "0.0.823";
        development = "0.0.96";
      };
  version = versions.${branch};
  srcs = rec {
    x86_64-linux = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        hash = "sha256-FB6GiCM+vGyjZLtF0GjAIq8etK5FYyQVisWX6IzB4Zc=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        hash = "sha256-GbLEAu6gchwkkupU6k6i7bpdMVnCqB74HDYxyTt3J/w=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        hash = "sha256-W7uPrJRKY4I6nsdj/TNxT8kHh5ssn9KyCArhOhAlaH4=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/linux/${version}/discord-development-${version}.tar.gz";
        hash = "sha256-KpZ90VekGf3KNpNpFfZlVXorv86yK1OuY0uqgBuWIQ4=";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://stable.dl2.discordapp.net/apps/osx/${version}/Discord.dmg";
        hash = "sha256-qHOLhPhHwN0fy1KiJroJvshlYExBDsuna2PddjtNyEI=";
      };
      ptb = fetchurl {
        url = "https://ptb.dl2.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
        hash = "sha256-Q153X08crRpXZMMgNDYbADHnL7MiBPCakJxQe8Pl0Uo=";
      };
      canary = fetchurl {
        url = "https://canary.dl2.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        hash = "sha256-69Q8kTfenlmhjptVSQ9Y0AyeViRw+srMExOA7fAlaGw=";
      };
      development = fetchurl {
        url = "https://development.dl2.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        hash = "sha256-fe7yE+dxEATIdfITg57evbaQkChCcoaLrzV+8KwEBws=";
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

  updateScript = writeScript "discord-update-all-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p git
    set -euo pipefail

    packages=(
        discord
        discord-ptb
        discord-canary
        discord-development
        pkgsCross.aarch64-darwin.discord
        pkgsCross.aarch64-darwin.discord-ptb
        pkgsCross.aarch64-darwin.discord-canary
        pkgsCross.aarch64-darwin.discord-development
    )

    for d in "''${packages[@]}"; do
        nix-shell maintainers/scripts/update.nix \
            --argstr commit true \
            --argstr skip-prompt true \
            --arg get-script 'pkg: pkg.actualUpdateScript or null' \
            --argstr package "$d"
    done

    commit_amount="$(git rev-list --count master..HEAD)"

    if [[ $commit_amount -eq 0 ]]; then
        echo "No updates"
        exit 0
    fi

    commit_msgs="$(git log -n $commit_amount --reverse --pretty=format:'%s%n%n%b' | sed '/^$/N;/^\n$/D')"

    git reset --soft HEAD~"$commit_amount"

    git commit -m "discord: Update all" -m "$commit_msgs"
  '';

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
