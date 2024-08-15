{ lib
, python3
, fetchFromGitHub
, wrapGAppsHook4
, appstream-glib
, desktop-file-utils
, gettext
, gtk4
, libadwaita
, meson
, ninja
, pkg-config
, gobject-introspection
, jpegoptim
, libwebp
, optipng
, pngquant
, oxipng
}:

python3.pkgs.buildPythonApplication rec {
  pname = "curtail";
  version = "1.10.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Huluti";
    repo = "Curtail";
    rev = "refs/tags/${version}";
    sha256 = "sha256-xwpjyMMdjYMrd79/EzoNae4rQuq2VjwJRNoudNGD78E=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
    gettext
    gtk4
    libadwaita
    meson
    ninja
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    appstream-glib
    gettext
    gtk4
    libadwaita
  ];

  propagatedBuildInputs = [
    python3.pkgs.pygobject3
  ];

  preInstall = ''
    patchShebangs ../build-aux/meson/postinstall.py
  '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      "--prefix" "PATH" ":" "${lib.makeBinPath [ jpegoptim libwebp optipng pngquant oxipng ]}"
    )
  '';

  meta = with lib; {
    description = "Simple & useful image compressor";
    mainProgram = "curtail";
    homepage = "https://github.com/Huluti/Curtail";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
