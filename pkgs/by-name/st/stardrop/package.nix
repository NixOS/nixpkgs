{ lib
, fetchFromGitHub
, buildFHSEnv
, appimageTools
, buildDotnetModule
, dotnetCorePackages
, writeShellScript
, makeDesktopItem
, copyDesktopItems
, extraThemes ? [ ]
}:

let
  pname = "stardrop";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Floogen";
    repo = "stardrop";
    rev = "v${version}";
    hash = "sha256-VN0SrvBT5JUNraeh6YyRhcnoOl+mOB2/zk/rQeJidI8=";
  };

  unwrapped = buildDotnetModule {
    inherit pname version src;

    patches = [ ./csproj-build.patch ];

    projectFile = "Stardrop/Stardrop.csproj";
    executables = ["Stardrop"];

    dotnet-sdk = dotnetCorePackages.sdk_7_0;
    dotnet-runtime = dotnetCorePackages.runtime_7_0;
    nugetDeps = ./deps.nix;

    postInstall = ''
      mkdir -pv $out/share/icon/
      cp Stardrop/Assets/icon.ico $out/share/icon/stardrop.ico
      for theme in ${lib.concatStringsSep " " (map (t: "${t}") extraThemes)}; do
        cp -rv $theme $out/lib/stardrop/Themes/
      done
    '';

    nativeBuildInputs = [ copyDesktopItems ];

    desktopItems = [
    (makeDesktopItem {
      name = "Stardrop";
      exec = "stardrop";
      icon = "stardrop";
      desktopName = "stardrop";
      comment = meta.description;
      categories = [ "Game" ];
      startupWMClass = "stardrop";
      })
    ];
  };

  meta = {
    description = "Open-source, cross-platform mod manager for the game Stardew Valley";
    homepage = "https://github.com/Floogen/Stardrop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jh-devv ];
    platforms = lib.platforms.all;
  };

  fhs = buildFHSEnv (
    appimageTools.defaultFhsEnvArgs // {
      inherit pname version meta;
      runScript = writeShellScript "stardrop-wrapper.sh" ''
        exec ${unwrapped}/bin/Stardrop "$@"
      '';

      extraInstallCommands = ''
        cp -r ${unwrapped}/share $out/share
      '';
    }
  );

in fhs
