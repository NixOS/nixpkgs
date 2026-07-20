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
  version = "20251212";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/osinfo-db-${finalAttrs.version}.tar.xz";
    hash = "sha256-BjeSUMkTBsmMuXJq9E6uWQnf3VRJ+QMx6QSuEiHY1ec=";
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
