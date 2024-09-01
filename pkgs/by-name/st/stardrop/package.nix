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
  # Function to convert a word to PascalCase
  pascal = x: lib.toUpper (lib.substring 0 1 x) + lib.substring 1 (lib.stringLength x) x;

  pname = "stardrop";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Floogen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VN0SrvBT5JUNraeh6YyRhcnoOl+mOB2/zk/rQeJidI8=";
  };

  unwrapped = buildDotnetModule {
    inherit pname version src;

    patches = [ ./csproj-build.patch ];

    projectFile = "${pascal pname}/${pascal pname}.csproj";
    executables = ["${pascal pname}"];

    dotnet-sdk = dotnetCorePackages.sdk_7_0;
    dotnet-runtime = dotnetCorePackages.runtime_7_0;
    nugetDeps = ./deps.nix;

    postInstall = ''
      mkdir -pv $out/share/icon/
      cp ${pascal pname}/Assets/icon.ico $out/share/icon/${pname}.ico
      for theme in ${lib.concatStringsSep " " (map (t: "${t}") extraThemes)}; do
        cp -rv $theme $out/lib/${pname}/Themes/
      done
    '';

    nativeBuildInputs = [ copyDesktopItems ];

    desktopItems = [
    (makeDesktopItem {
      name = "${pascal pname}";
      exec = "${pname}";
      icon = "${pname}";
      comment = meta.description;
      desktopName = "${pname}";
      categories = [ "Game" ];
      startupWMClass = "${pname}";
      })
    ];
  };

  meta = {
    description = "Stardrop is an open-source, cross-platform mod manager for the game Stardew Valley";
    homepage = "https://github.com/Floogen/Stardrop";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jh-devv ];
    platforms = lib.platforms.all;
  };

  fhs = buildFHSEnv (
    appimageTools.defaultFhsEnvArgs // {
      inherit pname version meta;
      runScript = writeShellScript "${pname}-wrapper.sh" ''
        exec ${unwrapped}/bin/${pascal pname} "$@"
      '';

      extraInstallCommands = ''
        cp -r ${unwrapped}/share $out/share
      '';
    }
  );

in fhs
