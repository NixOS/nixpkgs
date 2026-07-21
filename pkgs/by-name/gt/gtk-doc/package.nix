{
  lib,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3,
  docbook_xml_dtd_43,
  docbook-xsl-nons,
  libxslt,
  gettext,
  gnome,
  withDblatex ? false,
  dblatex,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gtk-doc";
  version = "1.36.1";

  outputDevdoc = "out";

  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gtk-doc";
    tag = version;
    hash = "sha256-8hB43BCAtT1B7/ak2i0FAlYD3Kb4rNCWfsJ+wqGu3FA=";
  };

  postPatch = ''
    substituteInPlace meson.build \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  strictDeps = true;

  depsBuildBuild = [
    python3
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    meson
    ninja
    libxslt # for xsltproc
  ];

  buildInputs = [
    docbook_xml_dtd_43
    docbook-xsl-nons
    libxslt
  ]
  ++ lib.optionals withDblatex [
    dblatex
  ];

  pythonPath = with python3.pkgs; [
    pygments # Needed for https://gitlab.gnome.org/GNOME/gtk-doc/blob/GTK_DOC_1_32/meson.build#L42
    lxml
  ];

  mesonFlags = [
    "-Dtests=false"
    "-Dyelp_manual=false"
  ];

  doCheck = false; # requires a lot of stuff
  doInstallCheck = false; # fails

  postFixup = ''
    # Do not propagate Python
    substituteInPlace $out/nix-support/propagated-build-inputs \
      --replace "${python3}" ""
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gtk-doc";
      versionPolicy = "none";
    };
  };

  meta = {
    changelog = "https://gitlab.gnome.org/GNOME/gtk-doc/-/blob/${src.tag}/NEWS";
    description = "Tools to extract documentation embedded in GTK and GNOME source code";
    homepage = "https://gitlab.gnome.org/GNOME/gtk-doc";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pSub ];
    teams = [ lib.teams.gnome ];
  };
}
