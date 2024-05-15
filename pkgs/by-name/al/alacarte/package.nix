{
  lib,
  fetchFromGitLab,
  python3,
  autoconf,
  automake,
  gettext,
  pkg-config,
  libxslt,
  gobject-introspection,
  wrapGAppsHook3,
  gnome-menus,
  glib,
  gtk3,
  docbook_xsl,
  nix-update-script,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "alacarte";
  version = "3.52.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "alacarte";
    rev = version;
    hash = "sha256-SkolSk6RireH3aKkRTUCib/nflqD02PR9uVtXePRHQY=";
  };

  format = "other";

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    pkg-config
    python3
    libxslt
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gnome-menus
    glib
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [ pygobject3 ];

  configureScript = "./autogen.sh";

  # Builder couldn't fetch the docbook.xsl from the internet directly,
  # so we substitute it with the docbook.xsl in already in nixpkgs
  preConfigure = ''
    substituteInPlace man/Makefile.am \
      --replace-fail "http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl" "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/alacarte";
    description = "A menu editor for GNOME using the freedesktop.org menu specification";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "alacarte";
    maintainers = with lib.maintainers; [ pluiedev ];
  };
}
