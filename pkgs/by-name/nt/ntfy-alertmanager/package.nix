{
  buildGoModule,
  fetchurl,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "ntfy-alertmanager";
  version = "1.0.1";

  src = fetchurl {
    url = "https://git.xenrox.net/~xenrox/ntfy-alertmanager/refs/download/v${finalAttrs.version}/ntfy-alertmanager-${finalAttrs.version}.tar.gz";
    hash = "sha256-L5WyJ+O45OKAwdhMGb+j/UQSz19nwdUx7bEzyRsN8j0=";
  };

  vendorHash = "sha256-0yMQXeKHKdlELTu8uIRqXzaW601LHNTqkl3MwxGq9u4=";

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
