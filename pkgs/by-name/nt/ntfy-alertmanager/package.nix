{
  buildGoModule,
  fetchurl,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "ntfy-alertmanager";
  version = "1.0.2";

  src = fetchurl {
    url = "https://git.xenrox.net/~xenrox/ntfy-alertmanager/refs/download/v${finalAttrs.version}/ntfy-alertmanager-${finalAttrs.version}.tar.gz";
    hash = "sha256-1xTk27oyEOeUY9T+4Lzk/tCLTs0QG2oPff+m3fGeG5o=";
  };

  vendorHash = "sha256-PfC9gfoXiIMNCEZNKKufW5Ar0TQf66fVSS/iEXSTJfs=";

  meta = {
    description = "Bridge between ntfy and Alertmanager";
    homepage = "https://git.xenrox.net/~xenrox/ntfy-alertmanager";
    license = lib.licenses.agpl3Only;
    mainProgram = "ntfy-alertmanager";
    maintainers = with lib.maintainers; [
      bleetube
      fpletz
    ];
    platforms = lib.platforms.linux;
  };
})
