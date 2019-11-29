{ stdenv, fetchFromGitHub, meson, ninja, gettext, python3, fetchpatch,
  pkgconfig, libxml2, json-glib , sqlite, itstool, librsvg, yelp-tools,
  vala, gtk3, gnome3, desktop-file-utils, wrapGAppsHook, gobject-introspection
}:

stdenv.mkDerivation rec {
  pname = "font-manager";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "FontManager";
    repo = "master";
    rev = version;
    sha256 = "16hma8rrkam6ngn5vbdaryn31vdixvii6920g9z928gylz9xkd3g";
  };

  nativeBuildInputs = [
    pkgconfig
    meson
    ninja
    gettext
    python3
    itstool
    desktop-file-utils
    vala
    yelp-tools
    wrapGAppsHook
    # For https://github.com/FontManager/master/blob/master/lib/unicode/meson.build
    gobject-introspection
  ];

  buildInputs = [
    libxml2
    json-glib
    sqlite
    librsvg
    gtk3
    gnome3.adwaita-icon-theme
  ];

  mesonFlags = [
    "-Ddisable_pycompile=true"
  ];

  patches = [
    # fix build with Vala 0.46
    (fetchpatch {
      url = "https://github.com/FontManager/font-manager/commit/c73b40de11f376f4515a0edfe97fb3721a264b35.patch";
      sha256 = "0lacwsifgvda2r3z6j2a0svdqr6mgav7zkvih35xa8155y8wfpnw";
      excludes = [ "fedora/font-manager.spec" ];
    })
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  meta = with stdenv.lib; {
    homepage = https://fontmanager.github.io/;
    description = "Simple font management for GTK desktop environments";
    longDescription = ''
      Font Manager is intended to provide a way for average users to
      easily manage desktop fonts, without having to resort to command
      line tools or editing configuration files by hand. While designed
      primarily with the Gnome Desktop Environment in mind, it should
      work well with other GTK desktop environments.

      Font Manager is NOT a professional-grade font management solution.
    '';
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
