{
  lib,
  stdenv,
  fetchurl,
  osinfo-db-tools,
  gettext,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db";
  version = "20250606";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/${pname}-${version}.tar.xz";
    hash = "sha256-mUCqR98pgHPFHc+KTcyFX0lKuGTCTNvaRr2JeVc1f+E=";
  };

  nativeBuildInputs = [
    osinfo-db-tools
    gettext
    libxml2
  ];

  installPhase = ''
    osinfo-db-import --dir "$out/share/osinfo" "${src}"
  '';

  meta = {
    description = "Osinfo database of information about operating systems for virtualization provisioning tools";
    homepage = "https://gitlab.com/libosinfo/osinfo-db/";
    changelog = "https://gitlab.com/libosinfo/osinfo-db/-/commits/v${version}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
  };
}
