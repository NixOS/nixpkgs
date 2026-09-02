{
  lib,
  stdenv,
  fetchurl,
  osinfo-db-tools,
  gettext,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "osinfo-db";
  version = "20260812";

  src = fetchurl {
    url = "https://gitlab.com/api/v4/projects/libosinfo%2Fosinfo-db/packages/generic/release-assets/v${finalAttrs.version}/osinfo-db-${finalAttrs.version}.tar.xz";
    hash = "sha256-8T7W4eSAtSZtOcrX8AEP698CZd/EVXneL7NFQ7xrNd4=";
  };

  nativeBuildInputs = [
    osinfo-db-tools
    gettext
    libxml2
  ];

  installPhase = ''
    osinfo-db-import --dir "$out/share/osinfo" "${finalAttrs.src}"
  '';

  meta = {
    description = "Osinfo database of information about operating systems for virtualization provisioning tools";
    homepage = "https://gitlab.com/libosinfo/osinfo-db/";
    changelog = "https://gitlab.com/libosinfo/osinfo-db/-/commits/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
