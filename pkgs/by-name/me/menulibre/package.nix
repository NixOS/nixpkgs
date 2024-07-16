{ lib
, fetchFromGitHub
, python3Packages
, gnome-menus
, gtk3
, intltool
, gobject-introspection
, wrapGAppsHook3
, nix-update-script
, versionCheckHook
}:

python3Packages.buildPythonApplication rec {
  pname = "menulibre";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "bluesabre";
    repo = "menulibre";
    rev = "menulibre-${version}";
    hash = "sha256-IfsuOYP/H3r1GDWMVVSBfYvQS+01VJaAlZu+c05geWg=";
  };

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    gnome-menus
    psutil
    distutils-extra
  ];

  nativeBuildInputs = [
    gtk3
    intltool
    gobject-introspection
    wrapGAppsHook3
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'data_dir =' "data_dir = '$out/share/menulibre' #" \
      --replace-fail 'update_desktop_file(desktop_file, script_path)' ""
  '';

  preBuild = ''
    export HOME=$TMPDIR
  '';

  preVersionCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Advanced menu editor with an easy-to-use interface";
    homepage = "https://bluesabre.org/projects/menulibre";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lelgenio ];
    mainProgram = "menulibre";
    platforms = platforms.linux;
  };
}
