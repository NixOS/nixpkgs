{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk-doc,
  glib,
  intltool,
  menu-cache,
  pango,
  pkg-config,
  vala,
  gtk3,
  extraOnly ? false,
}:

let
  inherit (lib) optional optionalString;
in
stdenv.mkDerivation (finalAttrs: {
  pname = if extraOnly then "libfm-extra" else "libfm";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = "libfm";
    tag = finalAttrs.version;
    hash = "sha256-HOx3L5IYPD/3Ez5Sb3nshfisIt1cIZJmdfGE6+q5gWE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    vala
    pkg-config
    intltool
    gtk-doc
  ];
  buildInputs = [
    glib
    gtk3
    pango
  ]
  ++ optional (!extraOnly) menu-cache;

  configureFlags = [
    "--sysconfdir=/etc"
    "--with-gtk=3"
  ]
  ++ optional extraOnly "--with-extra-only";

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
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
