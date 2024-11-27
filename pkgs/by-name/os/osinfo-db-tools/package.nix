{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, meson
, ninja
, gettext
, glib
, libxml2
, perl
, python3
, libxslt
, libarchive
, bzip2
, xz
, json-glib
, libsoup_3
}:

stdenv.mkDerivation rec {
  pname = "osinfo-db-tools";
  version = "1.11.0";

  src = fetchurl {
    url = "https://releases.pagure.org/libosinfo/osinfo-db-tools-${version}.tar.xz";
    sha256 = "sha256-i6bTG7XvBwVuOIeeBwZxr7z+wOtBqH+ZUEULu4MbCh0=";
  };

  patches = [
    # Fix build with libxml 2.12
    (fetchpatch {
      url = "https://gitlab.com/libosinfo/osinfo-db-tools/-/commit/019487cbc79925e49988789bf533c78dab7e1842.patch";
      hash = "sha256-skuspjHDRilwym+hFInrSvIZ+rrzBOoI7WeFj2SrGkc=";
    })
    (fetchpatch {
      url = "https://gitlab.com/libosinfo/osinfo-db-tools/-/commit/34378a4ac257f2f5fcf364786d1634a8c36b304f.patch";
      hash = "sha256-I9vRRbnotqRi8+7q1eZLJwQLaT9J4G3h+3rKxlaCME4=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    perl
    python3
  ];

  buildInputs = [
    glib
    json-glib
    libxml2
    libxslt
    libarchive
    bzip2
    xz
    libsoup_3
  ];

  meta = with lib; {
    description = "Tools for managing the osinfo database";
    homepage = "https://libosinfo.org/";
    changelog = "https://gitlab.com/libosinfo/osinfo-db-tools/-/blob/v${version}/NEWS";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
