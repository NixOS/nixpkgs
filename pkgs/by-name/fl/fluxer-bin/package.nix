{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  imagemagick,
}:

let
  pname = "fluxer-bin";
  version = "2026.1018.223338";

  sources = {
    x86_64-linux = {
      arch = "x64";
      hash = "sha256-G6aJZK6de60C0XDsolj/XIaWyBEeS8D6tTVAp2VV4Cw=";
    };
    aarch64-linux = {
      arch = "arm64";
      hash = "sha256-5OcAs3bveKjmmgqUjkMNe+TfY5Eds+98/6YNjmSmSUQ=";
    };
  };

  source = sources.${stdenv.hostPlatform.system} or sources.x86_64-linux;

  src = fetchurl {
    name = "${pname}-${version}.AppImage";
    url = "https://pkgs.fluxer.com/desktop/stable/linux/${source.arch}/${version}/appimage";
    inherit (source) hash;
  };

  upstreamName = "fluxer";
  desktopName = "app.fluxer.FluxerDesktop";
  optBinary = "/opt/Fluxer/fluxer";

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ imagemagick ];

  extraPkgs =
    pkgs: with pkgs; [
      libnotify # desktop notifications
      libappindicator # tray icon
      libdbusmenu-gtk3 # libappindicator dependency
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
      --replace-fail '"${optBinary}"' '${pname}'

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
    description = "Free and open source instant messaging and VoIP chat app (stable channel)";
    longDescription = ''
      Fluxer is a self-hostable chat platform with messaging, voice, video and
      communities. This packages the stable channel.
    '';
    homepage = "https://fluxer.app";
    downloadPage = "https://fluxer.app/download";
    changelog = "https://fluxer.app/blog";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ cashewna ];
    platforms = lib.attrNames sources;
    mainProgram = pname;
  };
}
