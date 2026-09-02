{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeShellWrapper,
  electron_42,
  addDriverRunpath,
  xdg-utils,
  commandLineArgs ? "",
}:

let
  sourcesJson = lib.importJSON ./sources.json;
  sources = lib.mapAttrs (
    _: info:
    fetchurl {
      inherit (info) url hash;
    }
  ) sourcesJson.sources;

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "grok-bot";
  inherit (sourcesJson) version;

  src = source;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeShellWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/grok-bot"
    cp -a "opt/Grok Bot/resources/app.asar" "$out/share/grok-bot/"
    cp -a "opt/Grok Bot/resources/app.asar.unpacked" "$out/share/grok-bot/"

    cp -r usr/share/icons "$out/share/"
    install -Dm644 usr/share/applications/grok-bot.desktop \
      "$out/share/applications/grok-bot.desktop"
    substituteInPlace "$out/share/applications/grok-bot.desktop" \
      --replace-fail '"/opt/Grok Bot/grok-bot"' "grok-bot"

    runHook postInstall
  '';

  preFixup = ''
    makeShellWrapper ${lib.getExe electron_42} "$out/bin/grok-bot" \
      --add-flags "$out/share/grok-bot/app.asar" \
      --add-flags --class=grok-bot \
      --add-flags --name=grok-bot \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${addDriverRunpath.driverLink}/lib \
      --prefix XDG_DATA_DIRS : "$out/share" \
      --set-default CHROME_DESKTOP grok-bot.desktop \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    ln -s grok-bot "$out/bin/sand"
  '';

  passthru = {
    inherit (sourcesJson) commitSha;
    sources = sourcesJson.sources;
    electron = electron_42;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Grok Bot desktop agent";
    homepage = "https://x.ai/bot";
    downloadPage = "https://x.ai/bot";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames sourcesJson.sources;
    mainProgram = "grok-bot";
  };
}
