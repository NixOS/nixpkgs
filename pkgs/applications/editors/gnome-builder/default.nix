{ stdenv
, desktop-file-utils
, docbook_xsl
, fetchurl
, flatpak
, gnome3
, gobjectIntrospection
, gspell
, gtk-doc
, gtk3
, gtksourceview3
, hicolor-icon-theme
, json-glib
, jsonrpc-glib
, libdazzle
, libxml2
, meson
, ninja
, ostree
, pcre
, pkgconfig
, python3
, sysprof
, template-glib
, vala
, webkitgtk
, wrapGAppsHook
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

  nativeBuildInputs = [
    #appstream-glib # tests fail if these tools are available
    desktop-file-utils
    docbook_xsl
    gobjectIntrospection
    gtk-doc
    hicolor-icon-theme
    meson
    ninja
    pkgconfig
    python3.pkgs.wrapPython
    wrapGAppsHook
  ];

  buildInputs = [
    flatpak
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
    ostree
    pcre
    python3
    sysprof
    template-glib
    vala
    webkitgtk
  ];

  outputDevdoc = "out";

  prePatch = ''
    patchShebangs build-aux/meson/post_install.py
  '';

  patches = [
    ./0001-Make-libide-s-install_dir-an-absolute-path.patch
    ./0002-Allow-packagers-to-specify-the-Python-libprefix.patch
    ./0003-Add-missing-ostree-1-dependency-to-flatpak-plugin.patch
  ];

  mesonFlags = [
    "-Dpython_libprefix=${python3.libPrefix}"
    "-Dwith_clang=false"
    "-Dwith_docs=true"
  ];

  pythonPath = with python3.pkgs; requiredPythonModules [ pygobject3 ];

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    )

    # Ensure that all plugins get their interpreter paths fixed up.
    find $out/lib -name \*.py -type f -print0 | while read -d "" f; do
      chmod a+x "$f"
    done
  '';

  #doCheck = true;

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    description = "An IDE for writing GNOME-based software";
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  }; 
}
