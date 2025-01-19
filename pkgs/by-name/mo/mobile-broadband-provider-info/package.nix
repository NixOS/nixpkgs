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
  version = "20240407";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${version}/${pname}-${version}.tar.xz";
    hash = "sha256-ib/v8hX0v/jpw/8uwlJQ/bCA0R6b+lnG/HGYKsAcgUo=";
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

  meta = with lib; {
    description = "Mobile broadband service provider database";
    homepage = "https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info";
    changelog = "https://gitlab.gnome.org/GNOME/mobile-broadband-provider-info/-/blob/${version}/NEWS?ref_type=tags";
    license = licenses.publicDomain;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
