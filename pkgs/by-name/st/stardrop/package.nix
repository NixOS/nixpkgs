{
  lib,
  imagemagick,
  fetchFromGitHub,
  buildFHSEnv,
  appimageTools,
  buildDotnetModule,
  dotnetCorePackages,
  writeShellScript,
  makeDesktopItem,
  copyDesktopItems,
  extraThemes ? [ ],
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
    executables = [ "Stardrop" ];

    dotnet-sdk = dotnetCorePackages.sdk_7_0;
    dotnet-runtime = dotnetCorePackages.runtime_7_0;
    nugetDeps = ./deps.nix;

    nativeBuildInputs = [
      copyDesktopItems
      imagemagick
    ];

    postInstall = builtins.concatStringsSep "\n" (
      map (theme: "cp ${theme} $out/lib/stardrop/Themes/${builtins.baseNameOf theme}") extraThemes
    );

    postFixup = ''
      for size in 16 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
          magick ${./stardrop.ico} -background none -resize "$size"x"$size" -flatten \
            $out/share/icons/hicolor/"$size"x"$size"/apps/stardrop.png
      done;
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "stardrop";
        desktopName = "Stardrop";
        exec = "stardrop --nxm %u";
        icon = "stardrop";
        comment = meta.description;
        categories = [ "Game" ];
        startupWMClass = "stardrop";
        mimeTypes = [ "x-scheme-handler/nxm" ];
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
    appimageTools.defaultFhsEnvArgs
    // {
      inherit pname version meta;
      runScript = writeShellScript "stardrop-wrapper.sh" ''
        exec ${unwrapped}/bin/Stardrop "$@"
      '';

      extraInstallCommands = ''
        cp -r ${unwrapped}/share $out/share
      '';
    }
  );

in
fhs
