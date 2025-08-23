{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  gtk-doc,
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

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libfm";
    tag = finalAttrs.version;
    hash = "sha256-SQHV4kv8Fz24x7g2G8qc+uJR9qeN1Ez1KHnKK9YULY0=";
  };

  patches = [
    # Add casts to fix -Werror=incompatible-pointer-types
    (fetchpatch {
      url = "https://github.com/lxde/libfm/commit/fbcd183335729fa3e8dd6a837c13a23ff3271000.patch";
      hash = "sha256-RbX8jkP/5ao6NWEnv8Pgy4zwZaiDsslGlRRWdoV3enA=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    vala
    pkg-config
    intltool
    gtk-doc
  ];
  buildInputs = [
    glib
    gtk
    pango
  ]
  ++ optional (!extraOnly) menu-cache;

  configureFlags = [
    "--sysconfdir=/etc"
  ]
  ++ optional extraOnly "--with-extra-only"
  ++ optional withGtk3 "--with-gtk=3";

  installFlags = [ "sysconfdir=${placeholder "out"}/etc" ];

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
