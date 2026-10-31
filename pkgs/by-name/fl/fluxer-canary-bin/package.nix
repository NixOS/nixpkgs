{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  imagemagick,
}:

let
  pname = "fluxer-canary-bin";
  version = "2026.1018.223341";

  sources = {
    x86_64-linux = {
      arch = "x64";
      hash = "sha256-pdp+SZhgXSSFxoN7lnrQLZEuPpSYEm/rPrTlJJECdMY=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-1bMvQaupSHPLSI5v5tnzUH6XhPrJvElx0r4Nu4cV/Bc=";
    };
  };

  # Deliberately falls back rather than throwing: a throw here would also break
  # evaluation on unsupported platforms. See nixpkgs#542642.
  source = sources.${stdenv.hostPlatform.system} or sources.x86_64-linux;

  src = fetchurl {
    name = "${pname}-${version}.AppImage";
    url = "https://pkgs.fluxer.com/desktop/canary/linux/${source.arch}/${version}/appimage";
    inherit (source) hash;
  };

  # The AppImage is still built under upstream's canary branding, so everything
  # inside it - the binary, the icon, the desktop entry's basename and its
  # Icon= key - is named this regardless of what the package is called.
  upstreamName = "fluxer-canary";
  desktopName = "app.fluxer.FluxerDesktopCanary";

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Build-time only: used by extraInstallCommands to rescale the icon.
  nativeBuildInputs = [ imagemagick ];

  extraPkgs =
    pkgs: with pkgs; [
      # Electron dlopens these at runtime; they are not in appimageTools'
      # default environment.
      libnotify # desktop notifications
      libappindicator # tray icon
      speechd-minimal # Chromium text-to-speech

      libva.out
    ];

  profile = ''
    export FLUXER_DISABLE_DESKTOP_FILE=1
  '';

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/${desktopName}.desktop -t $out/share/applications

    substituteInPlace $out/share/applications/${desktopName}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}' \
      --replace-fail '"/opt/${upstreamName}/${upstreamName}"' '${pname}'

    # Upstream ships a single 1024x1024 icon, which is not a size hicolor's
    # index lists, so some launchers fail to find it. Keep the original and
    # scale it down into the standard sizes.
    install -Dm444 \
      ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/${upstreamName}.png \
      $out/share/icons/hicolor/1024x1024/apps/${upstreamName}.png

    for size in 16 24 32 48 64 128 256 512; do
      dir=$out/share/icons/hicolor/''${size}x''${size}/apps
      mkdir -p "$dir"
      magick \
        ${appimageContents}/usr/share/icons/hicolor/1024x1024/apps/${upstreamName}.png \
        -resize ''${size}x''${size} "$dir/${upstreamName}.png"
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Free and open source instant messaging and VoIP chat app (canary channel)";
    longDescription = ''
      Fluxer is a self-hostable chat platform with messaging, voice, video and
      communities. This packages the canary channel, which receives frequent
      pre-release builds.
    '';
    homepage = "https://fluxer.app";
    downloadPage = "https://canary.fluxer.app/download";
    changelog = "https://fluxer.app/blog";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ deekahy ];
    platforms = lib.attrNames sources;
    mainProgram = pname;
  };
}
