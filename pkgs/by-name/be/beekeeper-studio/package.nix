{ appimageTools
, fetchurl
, lib
, makeWrapper
, stdenv
}:

let
  pname = "beekeeper-studio";
  version = "4.3.4";

  plat = {
    aarch64-linux = "-arm64";
    x86_64-linux = "";
  }.${stdenv.hostPlatform.system};

  hash = {
    aarch64-linux = "sha256-RzPw+jsHecOYSBn/TrEFew5V0LvYS15dUuscS7+GraM=";
    x86_64-linux = "sha256-RT+A2rq0rMv2o0au5cfcZJysGy+7xYvBDfEJ/TyJmZw=";
  }.${stdenv.hostPlatform.system};

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
      --replace 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Modern and easy to use SQL client for MySQL, Postgres, SQLite, SQL Server, and more. Linux, MacOS, and Windows";
    homepage = "https://www.beekeeperstudio.io";
    changelog = "https://github.com/beekeeper-studio/beekeeper-studio/releases/tag/v${version}";
    license = licenses.gpl3Only;
    mainProgram = "beekeeper-studio";
    maintainers = with maintainers; [ milogert alexnortung ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
