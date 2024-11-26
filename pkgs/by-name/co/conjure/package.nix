{ fetchFromGitHub
, gobject-introspection
, lib
, libadwaita
, python3Packages
, wrapGAppsHook4
, meson
, ninja
, desktop-file-utils
, pkg-config
, appstream-glib
, gtk4
}:
python3Packages.buildPythonApplication rec {
  pname = "conjure";
  version = "0.1.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "nate-xyz";
    repo = "conjure";
    rev = "v${version}";
    hash = "sha256-qWeqUQxTTnmJt40Jm1qDTGGuSQikkurzOux8sZsmDQk=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    meson
    ninja
    pkg-config
    gtk4
  ];

  buildInputs = [
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    loguru
    wand
  ];

  nativeCheckInputs = with python3Packages; [
    pytest
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Magically transform your images";
    mainProgram = "conjure";
    longDescription = ''
      Resize, crop, rotate, flip images, apply various filters and effects,
      adjust levels and brightness, and much more. An intuitive tool for designers,
      artists, or just someone who wants to enhance their images.
      Built on top of the popular image processing library, ImageMagick with python
      bindings from Wand.
    '';
    homepage = "https://github.com/nate-xyz/conjure";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sund3RRR ];
  };
}
