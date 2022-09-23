{ lib
, python3
, fetchFromGitHub
, wrapGAppsHook
, appstream-glib
, desktop-file-utils
, gettext
, gtk3
, meson
, ninja
, pkg-config
, gobject-introspection
, jpegoptim
, libwebp
, optipng
, pngquant
}:

python3.pkgs.buildPythonApplication rec {
  pname = "curtail";
  version = "1.3.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "Huluti";
    repo = "Curtail";
    rev = "refs/tags/${version}";
    sha256 = "sha256-/xvkRXs1EVu+9RZM+TnyIGxFV2stUR9XHEmaJxsJ3V8=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    appstream-glib
    desktop-file-utils
    gettext
    gtk3
    meson
    ninja
    pkg-config
  ];

  propagatedBuildInputs = [
    appstream-glib
    python3.pkgs.pygobject3
    gobject-introspection
    gettext
  ];

  # Currently still required for the gobject-introspection setup hook
  strictDeps = false;

  preInstall = ''
    patchShebangs ../build-aux/meson/postinstall.py
  '';

  postInstall = ''
    wrapProgram $out/bin/curtail --prefix PATH : ${lib.makeBinPath [ jpegoptim libwebp optipng pngquant ]}
  '';

  meta = with lib; {
    description = "Simple & useful image compressor";
    homepage = "https://github.com/Huluti/Curtail";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ anselmschueler ];
  };
}
