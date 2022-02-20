{ branch ? "stable", pkgs, lib, stdenv }:
let
  inherit (pkgs) callPackage fetchurl;
  versions = if stdenv.isLinux then {
    stable = "0.0.17";
    ptb = "0.0.27";
    canary = "0.0.133";
  } else {
    stable = "0.0.264";
    ptb = "0.0.59";
    canary = "0.0.283";
  };
  version = versions.${branch};
  srcs = let
    darwin-ptb = fetchurl {
      url = "https://dl-ptb.discordapp.net/apps/osx/${version}/DiscordPTB.dmg";
      sha256 = "sha256-LS7KExVXkOv8O/GrisPMbBxg/pwoDXIOo1dK9wk1yB8=";
    };
  in {
    x86_64-linux = {
      stable = fetchurl {
        url =
          "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
        sha256 = "058k0cmbm4y572jqw83bayb2zzl2fw2aaz0zj1gvg6sxblp76qil";
      };
      ptb = fetchurl {
        url =
          "https://dl-ptb.discordapp.net/apps/linux/${version}/discord-ptb-${version}.tar.gz";
        sha256 = "0yphs65wpyr0ap6y24b0nbhq7sm02dg5c1yiym1fxjbynm1mdvqb";
      };
      canary = fetchurl {
        url =
          "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        sha256 = "0wx8wkgkzvw9094baa3dni834l0n4p6ih024bj1851sgwwnidb0a";
      };
    };
    x86_64-darwin = {
      stable = fetchurl {
        url = "https://dl.discordapp.net/apps/osx/${version}/Discord.dmg";
        sha256 = "1jvlxmbfqhslsr16prsgbki77kq7i3ipbkbn67pnwlnis40y9s7p";
      };
      ptb = darwin-ptb;
      canary = fetchurl {
        url =
          "https://dl-canary.discordapp.net/apps/osx/${version}/DiscordCanary.dmg";
        sha256 = "0mqpk1szp46mih95x42ld32rrspc6jx1j7qdaxf01whzb3d4pi9l";
      };
    };
    # Only PTB bundles a MachO Universal binary with ARM support.
    aarch64-darwin = { ptb = darwin-ptb; };
  };
  src = srcs.${stdenv.hostPlatform.system}.${branch};

  meta = with lib; {
    description = "All-in-one cross-platform voice and text chat for gamers";
    homepage = "https://discordapp.com/";
    downloadPage = "https://discordapp.com/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ ldesgoui MP2E devins2518 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ]
      ++ lib.optionals (branch == "ptb") [ "aarch64-darwin" ];
  };
  package = if stdenv.isLinux then ./linux.nix else ./darwin.nix;
  packages = {
    stable = callPackage package rec {
      inherit src version meta;
      pname = "discord";
      binaryName = "Discord";
      desktopName = "Discord";
    };
    ptb = callPackage package rec {
      inherit src version meta;
      pname = "discord-ptb";
      binaryName = "DiscordPTB";
      desktopName = "Discord PTB";
    };
    canary = callPackage package rec {
      inherit src version meta;
      pname = "discord-canary";
      binaryName = "DiscordCanary";
      desktopName = "Discord Canary";
    };
  };
in packages.${branch}
