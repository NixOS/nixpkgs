{
  buildGoModule,
  fetchurl,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "ntfy-alertmanager";
  version = "0.5.0";

  src = fetchurl {
    url = "https://git.xenrox.net/~xenrox/ntfy-alertmanager/refs/download/v${finalAttrs.version}/ntfy-alertmanager-${finalAttrs.version}.tar.gz";
    hash = "sha256-Sn2hPt03o4Pi1WY/3d5oWhWUt8x+3P8hoNPS58tj0Kw=";
  };

  vendorHash = "sha256-NHaLv+Ulzl4ev3a6OjZiacCSmYAtvqFFmbYzAp+4AFU=";

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
