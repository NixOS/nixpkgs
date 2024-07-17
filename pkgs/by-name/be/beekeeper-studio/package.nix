{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
}:

let
  pname = "beekeeper-studio";
  version = "4.6.2";

  plat =
    {
      aarch64-linux = "-arm64";
      x86_64-linux = "";
    }
    .${stdenv.hostPlatform.system};

  hash =
    {
      aarch64-linux = "sha256-ZxqwxCON21S+RPG0/M2TtcI2Ave7ZT05lKQdyysQFUk=";
      x86_64-linux = "sha256-8sGFNoAsX+X3IJDXpwlYRt78nokauPYz88yDEYy6NP8=";
    }
    .${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/Beekeeper-Studio-${version}${plat}.AppImage";
    inherit hash;
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
    install -Dm444 ${appimageContents}/${pname}.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/${pname}.png -t $out/share/pixmaps/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
  '';

  meta = {
    description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more. Linux, MacOS, and Windows";
    homepage = "https://www.beekeeperstudio.io";
    changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "beekeeper-studio";
    maintainers = with lib.maintainers; [
      milogert
      alexnortung
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
