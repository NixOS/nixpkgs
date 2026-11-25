{
  lib,
  stdenv,
  fetchurl,
  jq,

  _7zz,
  autoPatchelfHook,
  dpkg,
  makeShellWrapper,
  wrapGAppsHook3,
  writeShellApplication,

  alsa-lib,
  at-spi2-core,
  coreutils,
  cups,
  glib,
  gnused,
  gtk3,
  libGL,
  libayatana-appindicator,
  libdrm,
  libgbm,
  libgcrypt,
  libkrb5,
  libnotify,
  libpulseaudio,
  libssh2,
  libuuid,
  libxdamage,
  nss,
  systemdLibs,

  commandLineArgs ? "",
  disableAutoUpdate ? true,
}@args:

let
  passthru = finalAttrs: {
    sources = lib.importJSON ./sources.json;
    source =
      finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

    src = with finalAttrs.passthru; fetchqq source.src.url source.src.hash;

    fetchqq =
      url: hash:
      fetchurl {
        inherit url hash;
        nativeBuildInputs = [ jq ];
        netrcPhase = ''
          touch netrc
          # https://github.com/flathub/com.qq.QQ/issues/274#issuecomment-5512982615
          signedUrl=$(
            curl -fsS --retry 3 --connect-timeout 15 --max-time 60 -X POST "https://im.qq.com/http2rpc/gotrpc/noauth/trpc.qqntv2.urlsign.UrlSign/GetSign" \
              -H "Content-Type: application/json" \
              -H 'x-oidb: {"uint32_command":"0x9b8e","uint32_service_type":1}' \
              --data ${lib.escapeShellArg (lib.toJSON { inherit url; })} \
              | jq -er '.data.url'
          )
          urls=("$signedUrl")
        '';
      };

    # nixpkgs-update: no auto update
    updateScript = ./update.sh;
  };

  meta = finalAttrs: {
    homepage = "https://im.qq.com/index/";
    description = "Messaging app";
    platforms = lib.attrNames finalAttrs.passthru.sources;
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      bot-wxt1221
      fee1-dead
      prince213
      ryan4yin
    ];
  };

  args' = args // {
    pname = "qq";
    inherit
      commandLineArgs
      disableAutoUpdate
      passthru
      meta
      ;
  };
in
if stdenv.hostPlatform.isDarwin then import ./darwin.nix args' else import ./linux.nix args'
