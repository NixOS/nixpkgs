{
  stdenv,
  cmake,
  pkg-config,
  gobject-introspection,
  vala,
  glib,
  libsndfile,
  zlib,
  bzip2,
  xz,
  libsamplerate,
  intltool,
  pcre,
  util-linux,
  libselinux,
  libsepol,
  fetchurl,
  lib,
  writeScript,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmirage";
  version = "3.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/cdemu/libmirage-${finalAttrs.version}.tar.xz";
    hash = "sha256-mstOGdmKJXRUrQA5F1DZGqVuY+f25Q5ZpdOXPx4MZRI=";
  };

  env = {
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_GIRDIR = "${placeholder "out"}/share/gir-1.0";
    PKG_CONFIG_GOBJECT_INTROSPECTION_1_0_TYPELIBDIR = "${placeholder "out"}/lib/girepository-1.0";
  };

  buildInputs = [
    glib
    libsndfile
    zlib
    bzip2
    xz
    libsamplerate
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    intltool
    gobject-introspection
    vala
  ];

  propagatedBuildInputs = [
    pcre
    util-linux
    libselinux
    libsepol
  ];

  passthru = {
    updateScript = writeScript "update-libmirage" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre2 common-updater-scripts

      set -eu -o pipefail

      # Fetch the latest version from the SourceForge RSS feed for libmirage
      newVersion="$(curl -s "https://sourceforge.net/projects/cdemu/rss?path=/libmirage" | pcre2grep -o1 'libmirage-([0-9.]+)\.tar\.xz' | head -n 1)"

      update-source-version libmirage "$newVersion"
    '';
  };

  meta = {
    maintainers = with lib.maintainers; [ bendlas ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    description = "CD-ROM image access library";
    homepage = "https://cdemu.sourceforge.io/about/libmirage/";
  };
})
