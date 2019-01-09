{ stdenv, fetchurl, substituteAll, meson, ninja, pkgconfig, vala_0_40, gettext
, gnome3, libnotify, itstool, glib, gtk3, libxml2
, coreutils, libsecret, pcre, libxkbcommon, wrapGAppsHook
, libpthreadstubs, libXdmcp, epoxy, at-spi2-core, dbus, libgpgerror
, appstream-glib, desktop-file-utils, duplicity
}:

stdenv.mkDerivation rec {
  name = "deja-dup-${version}";
  version = "38.1";

  src = fetchurl {
    url = "https://launchpad.net/deja-dup/${stdenv.lib.versions.major version}/${version}/+download/deja-dup-${version}.tar.xz";
    sha256 = "0wm7z72qbsljzsysxg8h5sbpg56ignn9mp8v3xynn12dv3gv6rba";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils;
    })
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    substituteInPlace deja-dup/nautilus/NautilusExtension.c --subst-var-by DEJA_DUP_GSETTINGS_PATH $out/share/gsettings-schemas/${name}/glib-2.0/schemas
  '';

  nativeBuildInputs = [
    meson ninja pkgconfig vala_0_40 gettext itstool
    appstream-glib desktop-file-utils libxml2 wrapGAppsHook
  ];

  buildInputs = [
   libnotify gnome3.libpeas glib gtk3 libsecret
   pcre libxkbcommon libpthreadstubs libXdmcp epoxy gnome3.nautilus
   at-spi2-core dbus gnome3.gnome-online-accounts libgpgerror
  ];

  propagatedUserEnvPkgs = [ duplicity ];

  PKG_CONFIG_LIBNAUTILUS_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/lib/nautilus/extensions-3.0";

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  postFixup = ''
    # Unwrap accidentally wrapped library
    mv $out/libexec/deja-dup/tools/.libduplicity.so-wrapped $out/libexec/deja-dup/tools/libduplicity.so
  '';

  meta = with stdenv.lib; {
    description = "A simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = https://launchpad.net/deja-dup;
    license = with licenses; gpl3;
    maintainers = with maintainers; [ jtojnar joncojonathan ];
    platforms = with platforms; linux;
  };
}
