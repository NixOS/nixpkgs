{ stdenv, fetchFromGitLab, substituteAll, meson, ninja, pkgconfig, vala_0_40, gettext
, gnome3, libnotify, itstool, glib, gtk3, libxml2
, coreutils, libsecret, pcre, libxkbcommon, wrapGAppsHook
, libpthreadstubs, libXdmcp, epoxy, at-spi2-core, dbus, libgpgerror
, appstream-glib, desktop-file-utils, duplicity
}:

stdenv.mkDerivation rec {
  pname = "deja-dup";
  version = "38.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = pname;
    rev = version;
    sha256 = "1bnvmdlm67k1b6115x75j3nl92x5yl4psq5pna2w6cg9npxdd3fa";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit coreutils;
    })
    ./hardcode-gsettings.patch
  ];

  postPatch = ''
    substituteInPlace deja-dup/nautilus/NautilusExtension.c --subst-var-by DEJA_DUP_GSETTINGS_PATH $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
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
    homepage = https://wiki.gnome.org/Apps/DejaDup;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar joncojonathan ];
    platforms = platforms.linux;
  };
}
