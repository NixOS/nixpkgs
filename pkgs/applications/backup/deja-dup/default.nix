{ stdenv, fetchurl, meson, ninja, pkgconfig, vala_0_38, gettext
, gnome3, libnotify, intltool, itstool, glib, gtk3, libxml2
, coreutils, libsecret, pcre, libxkbcommon, wrapGAppsHook
, libpthreadstubs, libXdmcp, epoxy, at-spi2-core, dbus, libgpgerror
, appstream-glib, desktop-file-utils, duplicity
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
    appstream-glib desktop-file-utils libxml2 wrapGAppsHook
  ];

  buildInputs = [
   libnotify gnome3.libpeas glib gtk3 libsecret
   pcre libxkbcommon libpthreadstubs libXdmcp epoxy gnome3.nautilus
   at-spi2-core dbus gnome3.gnome-online-accounts libgpgerror
  ];

  propagatedUserEnvPkgs = [ duplicity ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  postFixup = ''
    # Unwrap accidentally wrapped library
    mv $out/libexec/deja-dup/tools/.libduplicity.so-wrapped $out/libexec/deja-dup/tools/libduplicity.so

    # Patched meson does not add internal libraries to rpath
    for elf in "$out/bin/.deja-dup-wrapped" "$out/libexec/deja-dup/.deja-dup-monitor-wrapped" "$out/libexec/deja-dup/tools/libduplicity.so"; do
      patchelf --set-rpath "$(patchelf --print-rpath "$elf"):$out/lib/deja-dup" "$elf"
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
