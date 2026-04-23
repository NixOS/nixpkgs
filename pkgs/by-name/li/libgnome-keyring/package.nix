{
  lib,
  stdenv,
  fetchurl,
  glib,
  dbus,
  libgcrypt,
  pkg-config,
  intltool,
  gobject-introspection,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgnome-keyring";
  version = "3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/libgnome-keyring/${lib.versions.majorMinor finalAttrs.version}/libgnome-keyring-${finalAttrs.version}.tar.xz";
    hash = "sha256-xMF4+7BfcqzEhNIt2wVo91MsQJsKE+BlE/9UuR6Ud4M=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  propagatedBuildInputs = [
    glib
    gobject-introspection
    dbus
    libgcrypt
  ];
  nativeBuildInputs = [
    pkg-config
    intltool
  ];

  configureFlags = [
    # not ideal to use -config scripts but it's not possible switch it to pkg-config
    # binaries in dev have a for build shebang
    "LIBGCRYPT_CONFIG=${lib.getExe' (lib.getDev libgcrypt) "libgcrypt-config"}"
  ];

  postPatch = ''
    # uses pkg-config in some places and uses the correct $PKG_CONFIG in some
    # it's an ancient library so it has very old configure scripts and m4
    substituteInPlace ./configure \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Framework for managing passwords and other secrets";
    homepage = "https://gitlab.gnome.org/Archive/libgnome-keyring";
    changelog = "https://gitlab.gnome.org/Archive/libgnome-keyring/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    pkgConfigModules = [ "gnome-keyring-1" ];
    platforms = lib.platforms.unix;
    maintainers = [ ];

    longDescription = ''
      gnome-keyring is a program that keeps password and other secrets for
      users. The library libgnome-keyring is used by applications to integrate
      with the gnome-keyring system.
    '';
  };
})
