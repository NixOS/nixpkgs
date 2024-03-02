{ lib
, fetchFromGitHub
, python3Packages
, gnome-menus
, gtk3
, intltool
, gobject-introspection
, wrapGAppsHook
, testers
, menulibre
}:

python3Packages.buildPythonApplication rec {
  name = "menulibre";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "bluesabre";
    repo = "menulibre";
    rev = "menulibre-${version}";
    hash = "sha256-E0ukq3q4YaakOI2mDs3dh0ncZX/dqspCA+97r3JwWyA=";
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
    wrapGAppsHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail 'data_dir =' "data_dir = '$out/share/menulibre' #" \
      --replace-fail 'update_desktop_file(desktop_file, script_path)' ""
  '';

  preBuild = ''
    export HOME=$TMPDIR
  '';

  passthru.tests.version = testers.testVersion {
    package = menulibre;
    command = "HOME=$TMPDIR menulibre --version | cut -d' ' -f2";
  };

  meta = with lib; {
    description = "An advanced menu editor with an easy-to-use interface";
    homepage = "https://bluesabre.org/projects/menulibre";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lelgenio ];
    mainProgram = "menulibre";
    platforms = platforms.linux;
  };
}
