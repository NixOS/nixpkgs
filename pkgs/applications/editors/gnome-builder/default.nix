{ stdenv, fetchurl, gnome3, gobjectIntrospection, meson, ninja, pkgconfig
, appstream-glib, desktop-file-utils, python3, python3Packages, wrapGAppsHook
, gspell, gtk3, gtksourceview3, json-glib, jsonrpc-glib, libdazzle, libxml2, pcre
, sysprof, template-glib, vala, webkitgtk
}:
let
  version = "3.28.4";
  pname = "gnome-builder";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${pname}-${version}.tar.xz";
    sha256 = "0ibb74jlyrl5f6rj1b74196zfg2qaf870lxgi76qzpkgwq0iya05";
  };

  buildInputs = [
    python3Packages.wrapPython
    wrapGAppsHook
    gobjectIntrospection
    meson
    ninja
    pkgconfig

    appstream-glib
    desktop-file-utils

    gnome3.devhelp
    gnome3.libgit2-glib
    gnome3.libpeas
    gnome3.vte
    gspell
    gtk3
    gtksourceview3
    json-glib
    jsonrpc-glib
    libdazzle
    libxml2
    pcre
    sysprof
    template-glib
    vala
    webkitgtk
  ];

  prePatch = ''
    sed -i 's@/usr/bin/env python3@${python3}/bin/python3@g' build-aux/meson/post_install.py
  '';

  patches = [
    ./python-libprefix.patch
  ];

  mesonFlags = [
    "-Dpython_libprefix=${python3.libPrefix}"
    "-Dwith_clang=false"
    "-Dwith_flatpak=false"
  ];

  pythonPath = with python3Packages; requiredPythonModules [ pygobject3 ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PATH : "$program_PATH"
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    )

    # Ensure that all plugins get their interpreter paths fixed up.
    find $out/lib -name \*.py -type f -print0 | while read -d "" f; do
      chmod a+x "$f"
    done
  '';

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    description = "An IDE for writing GNOME-based software";
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.gpl3;
    platforms = platforms.linux;
  }; 
}
