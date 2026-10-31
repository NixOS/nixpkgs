{
  lib,
  fetchFromCodeberg,
  wrapGAppsHook4,
  meson,
  ninja,
  desktop-file-utils,
  blueprint-compiler,
  libadwaita,
  gst_all_1,
  gobject-introspection,
  python3,
  python3Packages,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "laser";
  version = "0.5.0";
  pyproject = false;

  src = fetchFromCodeberg {
    owner = "andreasknoben";
    repo = "Laser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-i/wBWyStp2TpqCFEZS59ORgMiAM8gXANp23macuTUFk=";
  };

  __structuredAttrs = true;

  buildInputs = [
    libadwaita
    gst_all_1.gst-plugins-base
  ];

  nativeBuildInputs = [
    meson
    ninja
    blueprint-compiler
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  build-system = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    discid
    musicbrainzngs
    pycdio
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/laser --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "A simple CD ripper for the GNOME desktop";
    homepage = "https://codeberg.org/andreasknoben/Laser";
    maintainers = with lib.maintainers; [ lethargii ];
    changelog = "https://codeberg.org/andreasknoben/Laser/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "laser";
    platforms = lib.platforms.linux;
  };
})
