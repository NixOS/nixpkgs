{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  glib,
  intltool,
  menu-cache,
  pango,
  pkg-config,
  vala,
  extraOnly ? false,
  withGtk3 ? false,
  gtk2,
  gtk3,
}:

let
  gtk = if withGtk3 then gtk3 else gtk2;
  inherit (lib) optional optionalString;
in
stdenv.mkDerivation (finalAttrs: {
  pname = if extraOnly then "libfm-extra" else "libfm";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/pcmanfm/libfm-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-pQQmMDBM+OXYz/nVZca9VG8ii0jJYBU+02ajTofK0eU=";
  };

  patches = [
    # Add casts to fix -Werror=incompatible-pointer-types
    (fetchpatch {
      url = "https://github.com/lxde/libfm/commit/fbcd183335729fa3e8dd6a837c13a23ff3271000.patch";
      hash = "sha256-RbX8jkP/5ao6NWEnv8Pgy4zwZaiDsslGlRRWdoV3enA=";
    })
  ];

  nativeBuildInputs = [
    vala
    pkg-config
    intltool
  ];
  buildInputs = [
    glib
    gtk
    pango
  ] ++ optional (!extraOnly) menu-cache;

  configureFlags =
    [ "--sysconfdir=/etc" ]
    ++ optional extraOnly "--with-extra-only"
    ++ optional withGtk3 "--with-gtk=3";

  installFlags = [ "sysconfdir=${placeholder "out"}/etc" ];

  postPatch = ''
    # Ensure the files are re-generated from Vala sources.
    rm src/actions/*.c
  '';

  # libfm-extra is pulled in by menu-cache and thus leads to a collision for libfm
  postInstall = optionalString (!extraOnly) ''
    rm $out/lib/libfm-extra.so $out/lib/libfm-extra.so.* $out/lib/libfm-extra.la $out/lib/pkgconfig/libfm-extra.pc
  '';

  enableParallelBuilding = true;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://blog.lxde.org/category/pcmanfm/";
    license = lib.licenses.lgpl21Plus;
    description = "Glib-based library for file management";
    maintainers = with lib.maintainers; [ ttuegel ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
