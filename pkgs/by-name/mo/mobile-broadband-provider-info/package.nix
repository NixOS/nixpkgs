{
  lib,
  stdenv,
  fetchurl,
  gnome,
  libxslt,
  libxml2,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "mobile-broadband-provider-info";
  version = "20261111";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-5ZHB0yfClpZLGumeb5RYlSsfjiczemvEs/Po5VAWoYI=";
  };

  nativeBuildInputs = [
    libxslt # for xsltproc
    libxml2 # for xmllint
    meson
    ninja
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = pname; };
  };

  meta = {
    description = "Mobile broadband service provider database";
    homepage = "https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info";
    changelog = "https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info/-/blob/${version}/NEWS?ref_type=tags";
    license = lib.licenses.publicDomain;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
