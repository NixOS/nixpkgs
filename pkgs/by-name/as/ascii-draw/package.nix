{ lib
, python3Packages
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gobject-introspection
, wrapGAppsHook4
, desktop-file-utils
, libadwaita
}:

python3Packages.buildPythonApplication rec {
  pname = "ascii-draw";
  version = "0.3.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "ascii-draw";
    rev = "v${version}";
    hash = "sha256-vI+j8OuQ3b6La0+7wWeoUtBal24dazlN/T0Bng5TgMo=";
  };

  # Temporary fix for autosaving to flatpak directory
  # https://github.com/Nokse22/ascii-draw/issues/31
  patches = [ ./fix_palette_data_dir.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    desktop-file-utils
  ];

  buildInputs = [
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pyfiglet
    emoji
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "An app to draw diagrams or anything using only ASCII";
    homepage = "https://github.com/Nokse22/ascii-draw";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ascii-draw";
    maintainers = with lib.maintainers; [ aleksana ];
    # gnulib bindtextdomain is missing on various other unix platforms
    platforms = lib.platforms.linux;
  };
}
