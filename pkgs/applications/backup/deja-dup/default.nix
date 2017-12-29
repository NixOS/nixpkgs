{ stdenv, fetchurl, meson, ninja, pkgconfig, vala_0_38, gettext
, gnome3, libnotify, intltool, itstool, glib, gtk3, libxml2
, coreutils, libsecret, pcre, libxkbcommon, wrapGAppsHook
, libpthreadstubs, libXdmcp, epoxy, at_spi2_core, dbus, libgpgerror
, appstream-glib, desktop_file_utils, atk, pango, duplicity
}:

stdenv.mkDerivation rec {
  name = "deja-dup-${version}";
  version = "36.3";

  src = fetchurl {
    url = "https://launchpad.net/deja-dup/36/${version}/+download/deja-dup-${version}.tar.xz";
    sha256 = "08pwybzp7ynfcf0vqxfc3p8ir4gnzcv4v4cq5bwidbff9crklhrc";
  };

  patches = [
    ./fix-paths.patch
  ];

  postPatch = ''
    substituteInPlace libdeja/tools/duplicity/DuplicityInstance.vala --replace \
      "/bin/rm" \
      "${coreutils}/bin/rm"
  '';

  # couldn't find gio/gdesktopappinfo.h
  NIX_CFLAGS_COMPILE = "-I${glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [
    meson ninja pkgconfig vala_0_38 gettext intltool itstool
    appstream-glib desktop_file_utils libxml2 wrapGAppsHook
  ];

  buildInputs = [
   libnotify gnome3.libpeas glib gtk3 libsecret
   pcre libxkbcommon libpthreadstubs libXdmcp epoxy gnome3.nautilus
   at_spi2_core dbus gnome3.gnome_online_accounts libgpgerror
  ];

  propagatedUserEnvPkgs = [ duplicity ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  # Manual rpath definition until https://github.com/mesonbuild/meson/issues/314 is fixed
  postFixup =
    let
      rpath = stdenv.lib.makeLibraryPath [
        glib
        gtk3
        gnome3.gnome_online_accounts
        gnome3.libpeas
        gnome3.nautilus
        libgpgerror
        libsecret
        # Transitive
        atk
        pango
      ];
    in ''
      # Unwrap accidentally wrapped library
      mv $out/libexec/deja-dup/tools/.libduplicity.so-wrapped $out/libexec/deja-dup/tools/libduplicity.so

      for elf in "$out"/bin/.*-wrapped "$out"/libexec/deja-dup/.deja-dup-monitor-wrapped "$out"/libexec/deja-dup/tools/*.so "$out"/lib/deja-dup/*.so "$out"/lib/nautilus/extensions-3.0/*.so; do
        patchelf --set-rpath '${rpath}':"$out/lib/deja-dup" "$elf"
      done
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
