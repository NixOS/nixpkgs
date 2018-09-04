{ stdenv
, desktop-file-utils
, docbook_xsl
, docbook_xml_dtd_43
, fetchpatch
, fetchurl
, flatpak
, glibcLocales
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
    docbook_xml_dtd_43
    glibcLocales # for Meson's gtkdochelper
    gobjectIntrospection
    gtk-doc
    hicolor-icon-theme
    meson
    ninja
    pkgconfig
    python3
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

  outputs = [ "out" "devdoc" ];

  prePatch = ''
    patchShebangs build-aux/meson/post_install.py
  '';

  patches = [
    (fetchpatch {
      name = "absolute-shared-library-path.patch";
      url = "https://gitlab.gnome.org/GNOME/gnome-builder/commit/1011cabc519fd7322e2d695c79bfce3e18ff6200.patch";
      sha256 = "1g12zziidzrphp527aa8sklfaln4qpjprkz73f0c9w5ph6k252fw";
    })
    (fetchpatch {
      name = "python-libprefix.patch";
      url = "https://gitlab.gnome.org/GNOME/gnome-builder/commit/43494ce83a347f369ed4cfb8dd71d3b93452736b.patch";
      sha256 = "0kgi3n3g13n1j4xa61ln9xiahcfdc43bxi5mw4yva2d5px445msf";
    })
    (fetchpatch {
      name = "ostree-dependency.patch";
      url = "https://gitlab.gnome.org/GNOME/gnome-builder/commit/8b11773b65c95f464a0de16b91318c1ca73deeae.patch";
      sha256 = "18r4hd90id0w6r0lzqpw83bcj45nm9jhr46a0ffi1mcayb18mgbk";
    })
  ];

  mesonFlags = [
    "-Dpython_libprefix=${python3.libPrefix}"
    "-Dwith_docs=true"

    # Making the build system correctly detect clang header and library paths
    # is difficult. Somebody should look into fixing this.
    "-Dwith_clang=false"
  ];

  # Some tests fail due to being unable to find the Vte typelib, and I don't
  # understand why. Somebody should look into fixing this.
  doCheck = false;

  preInstall = ''
    export LC_ALL="en_US.utf-8"
  '';

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

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    description = "An IDE for writing GNOME-based software";
    longDescription = ''
      Global search, auto-completion, source code map, documentation
      reference, and other features expected in an IDE, but with a focus
      on streamlining GNOME-based development projects.

      This package does not pull in the dependencies needed for every
      plugin. If you find that a plugin you wish to use doesn't work, we
      currently recommend running gnome-builder inside a nix-shell with
      appropriate dependencies loaded.
    '';
    homepage = https://wiki.gnome.org/Apps/Builder;
    license = licenses.gpl3Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
