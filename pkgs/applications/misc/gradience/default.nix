{ lib
, fetchFromGitHub
, python3Packages
, wrapGAppsHook
, blueprint-compiler
, desktop-file-utils
, gobject-introspection
, libadwaita
, libsoup_3
, libportal-gtk4
, meson
, ninja
, pkg-config
, sassc
,
}:
let
  pythonDeps = with python3Packages; [
    pygobject3
    anyascii
    cssutils
    jinja2
    lxml
    material-color-utilities
    pillow
    pluggy
    regex
    svglib
    Yapsy
  ];
in
python3Packages.buildPythonApplication rec {
  pname = "gradience";
  version = "0.4.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "GradienceTeam";
    repo = "Gradience";
    rev = version;
    sha256 = "sha256-xR3wPU0ax9U4995GckC8UGJqrUErd+jS5z3D/jWCdXQ=";
  };

  nativeBuildInputs =
    [
      meson
      ninja
      blueprint-compiler
      desktop-file-utils
      gobject-introspection
      libsoup_3
      pkg-config
      sassc
      wrapGAppsHook
    ]
    ++ pythonDeps;

  buildInputs = [
    libadwaita
    libportal-gtk4
    libsoup_3
  ];

  pythonPath = pythonDeps;

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$out/lib $pythonPath"
  '';

  meta = with lib; {
    description = "A tool for customizing Libadwaita applications and the adw-gtk3 theme.";
    homepage = "https://gradienceteam.github.io/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ getchoo ];
    platforms = platforms.linux;
  };
}
