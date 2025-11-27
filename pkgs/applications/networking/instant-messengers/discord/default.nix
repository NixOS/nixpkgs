{
  callPackage,
  fetchurl,
  lib,
  stdenv,
  discord,
  discord-ptb,
  discord-canary,
  discord-development,
}:
let
  variants = rec {
    x86_64-linux = {
      discord = rec {
        branch = "stable";
        binaryName = desktopName;
        desktopName = "Discord";
        self = discord;
      };
      discord-ptb = {
        branch = "ptb";
        binaryName = "DiscordPTB";
        desktopName = "Discord PTB";
        self = discord-ptb;
      };
      discord-canary = {
        branch = "canary";
        binaryName = "DiscordCanary";
        desktopName = "Discord Canary";
        self = discord-canary;
      };
      discord-development = {
        branch = "development";
        binaryName = "DiscordDevelopment";
        desktopName = "Discord Development";
        self = discord-development;
      };
    };
    x86_64-darwin = {
      discord = rec {
        branch = "stable";
        binaryName = desktopName;
        desktopName = "Discord";
        self = discord;
      };
      discord-ptb = rec {
        branch = "ptb";
        binaryName = desktopName;
        desktopName = "Discord PTB";
        self = discord-ptb;
      };
      discord-canary = rec {
        branch = "canary";
        binaryName = desktopName;
        desktopName = "Discord Canary";
        self = discord-canary;
      };
      discord-development = rec {
        branch = "development";
        binaryName = desktopName;
        desktopName = "Discord Development";
        self = discord-development;
      };
    };

    aarch64-darwin = x86_64-darwin;
    default = x86_64-linux; # Used for unsupported platforms, so we can return *something* there.
  };

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

  sources = lib.importJSON ./sources.json;
in
lib.genAttrs [ "discord" "discord-ptb" "discord-canary" "discord-development" ] (
  pname:
  let
    args = (variants.${stdenv.hostPlatform.system} or variants.default).${pname};
    platformName = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
    source = sources."${platformName}-${args.branch}";
  in
  callPackage package (
    args
    // {
      inherit pname;
      inherit (source) version;

      src = fetchurl {
        inherit (source) url hash;
      };

      meta = meta // {
        mainProgram = args.binaryName;
      };
    }
  )
)
