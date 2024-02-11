{ libsepol
, libavif
, bash
, curl
, librsvg
, libselinux
, util-linux
, libwebp
, libheif
, lib
, stdenv
, fetchFromGitHub
, libxslt
, libxml2
, cmake
, exiftool
, openexr_3
, glib
, python3Packages
, perlPackages
, lensfun
, intltool
, pkg-config
, desktop-file-utils
, libffi
, gtk3
, libjpeg
, pugixml
, pcre
, pcre2
, lcms
, sqlite
, json-glib
, jasper
, libsecret
, gmic
, icu
, colord
, colord-gtk
, libaom
, libdatrie
, libsysprof-capture
, libde265
, isocodes
, libpsl
, libepoxy
, libsoup
, exiv2
, libXtst
, libthai
, x265
, libXdmcp
, openjpeg
, libgpg-error
, libxkbcommon
, osm-gps-map
, wrapGAppsHook
, rav1e
, dav1d
, libgcrypt
, graphicsmagick
, unstableGitUpdater
}:

let
    # requires libavif 0.x, see https://github.com/aurelienpierreeng/ansel/blob/e2c4a0a60cd80f741dd3d3c6ab72be9ac11234fb/src/CMakeLists.txt#L356
    libavif_0_11 = libavif.overrideAttrs rec {
      version = "0.11.1";

      src = fetchFromGitHub {
        owner = "AOMediaCodec";
        repo = "libavif";
        rev = "v${version}";
        hash = "sha256-mUi0DU99XV3FzUZ8/9uJZU+W3fc6Bk6+y6Z78IRZ9Qs=";
      };
    };
in
stdenv.mkDerivation {
  pname = "ansel";
  version = "unstable-2024-01-05";

  src = fetchFromGitHub {
    owner = "aurelienpierreeng";
    repo = "ansel";
    rev = "e2c4a0a60cd80f741dd3d3c6ab72be9ac11234fb";
    hash = "sha256-Kg020MHy9fn1drCk+66f25twqczvD/5evutDODqOjYM=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    desktop-file-utils
    exiftool
    intltool
    libxml2
    pkg-config
    perlPackages.perl
    python3Packages.jsonschema
    wrapGAppsHook
  ];

  buildInputs = [
    bash # for patchShebangs to patch scripts in share/ansel/tools/
    colord
    colord-gtk
    curl
    dav1d
    exiv2
    json-glib
    glib
    gmic
    graphicsmagick
    gtk3
    icu
    isocodes
    jasper
    lcms
    lensfun
    libaom
    libavif_0_11
    libdatrie
    libde265
    libepoxy
    libffi
    libgcrypt
    libgpg-error
    libheif
    libjpeg
    libpsl
    librsvg
    libsecret
    libselinux
    libsepol
    libsoup
    libsysprof-capture
    libthai
    libwebp
    libXdmcp
    libxkbcommon
    libxslt
    libXtst
    openexr_3
    openjpeg
    osm-gps-map
    pcre
    pcre2
    perlPackages.Po4a
    pugixml
    rav1e
    sqlite
    util-linux
    x265
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH ":" "$out/lib/ansel"
    )
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A darktable fork minus the bloat plus some design vision";
    homepage = "https://ansel.photos/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "ansel";
    platforms = lib.platforms.linux;
  };
}
