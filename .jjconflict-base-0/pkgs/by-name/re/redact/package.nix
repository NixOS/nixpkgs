{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
  writeScript,
}:
let
  pname = "redact";
  version = "0.18.0";
  src = fetchurl {
    url = "https://update-desktop.redact.dev/build/Redact-${version}.AppImage";
    hash = "sha256-qqqf8BAwXEKgZwl6vsPw/0S+qItz5ZqB59DJkW9q1xc=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    install -Dm444 ${appimageContents}/redact.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/redact.png -t $out/share/icons/hicolor/512x512/apps/redact.png
    substituteInPlace $out/share/applications/redact.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

  passthru.updateScript =
    writeScript "update.sh"
      /**
        Scraping the Windows URL for version is intentional, since
        the download link for Linux on redact.dev points to an older version,
        even though the Cloudflare bucket contains the latest Linux version.
      */
      ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p curl coreutils gnused common-updater-scripts
        set -eu -o pipefail
        url="$(curl -ILs -w %{url_effective} -o /dev/null https://download.redact.dev/windows)"
        version="$(echo $url | sed -n 's/.*Redact-Setup-\([0-9]\+\.[0-9]\+\.[0-9]\+\).*/\1/p')"
        currentVersion=$(nix-instantiate --eval -E "with import ./. {}; redact.version or (lib.getVersion redact)" | tr -d '"')
        if [[ "$version" != "$currentVersion" ]]; then
          hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url")")
          update-source-version redact "$version" "$hash" --print-changes
        fi
      '';

  meta = {
    description = "The only platform that allows you to automatically clean up your old posts from services like Twitter, Reddit, Facebook, Discord, and more, all in one place.";
    homepage = "https://redact.dev/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ reputable2772 ];
    mainProgram = "redact";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
