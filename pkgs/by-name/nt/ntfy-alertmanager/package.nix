{
  buildGoModule,
  fetchurl,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "ntfy-alertmanager";
  version = "1.0.0";

  src = fetchurl {
    url = "https://git.xenrox.net/~xenrox/ntfy-alertmanager/refs/download/v${finalAttrs.version}/ntfy-alertmanager-${finalAttrs.version}.tar.gz";
    hash = "sha256-SYDxwnSIUn0GVXIcD6ntf2l1Flaa4ebeTDdlXlNP6/M=";
  };

  vendorHash = "sha256-tqP/3yBkZQAAehNQVyU9j+jLBwBf/XWVQ+81Rz9+D2Y=";

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
