{ lib
, fetchFromGitLab
, meson
, ninja
, pkg-config
, python3
, docbook_xml_dtd_43
, docbook-xsl-nons
, libxslt
, gettext
, gnome
, withDblatex ? false, dblatex
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gtk-doc";
  version = "1.34.0";

  outputDevdoc = "out";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = version;
    hash = "sha256-Jt6d5wbhAoSQ2sWyYWW68Y81duc3+QOJK/5JR/lCmnQ=";
  };

  patches = [
    passthru.respect_xml_catalog_files_var_patch
  ];

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
  ] ++ lib.optionals withDblatex [
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
    # Consumers are expected to copy the m4 files to their source tree, let them reuse the patch
    respect_xml_catalog_files_var_patch = ./respect-xml-catalog-files-var.patch;
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "Tools to extract documentation embedded in GTK and GNOME source code";
    homepage = "https://gitlab.gnome.org/GNOME/gtk-doc";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members ++ (with maintainers; [ pSub ]);
  };
}
