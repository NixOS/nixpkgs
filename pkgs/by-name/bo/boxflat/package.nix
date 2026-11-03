{
  lib,
  fetchFromGitHub,
  gtk4,
  libadwaita,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook4,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  udevCheckHook,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "boxflat";
  version = "1.37.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lawstorant";
    repo = "boxflat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-509wOfzfbiMujaM8kaPHoWk8IhYlrgZnyom2PQpRqss=";
  };

  build-system = [ python3Packages.setuptools ];

  propagatedBuildInputs = [
    gtk4
    libadwaita

    python3Packages.pyyaml
    python3Packages.psutil
    python3Packages.pyserial
    python3Packages.pycairo
    python3Packages.pygobject3
    python3Packages.evdev
    python3Packages.dbus-python
    python3Packages.trayer
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook4
    gobject-introspection
    udevCheckHook
  ];

  pythonRelaxDeps = [
    "psutil"
    "evdev"
    "pycairo"
    "pygobject"
    "PyYAML"
    "dbus-python"
    "trayer"
  ];

  preBuild = ''
    substituteInPlace boxflat/app.py \
      --replace-fail 'if udev_exists and rules_version >= 2:' 'if udev_exists:'

    cat > setup.py << EOF
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    with open('entrypoint.py') as f:
        content = f.read()

    with open('boxflat/entrypoint.py', 'w') as f:
        f.write("def main():\n")
        for line in content.splitlines():
            f.write("    " + line + "\n")

    setup(
      name='boxflat',
      packages=['boxflat', 'boxflat.panels', 'boxflat.widgets'],
      version='${finalAttrs.version}',
      install_requires=install_requires,
      entry_points={
        'console_scripts': ['boxflat=boxflat.entrypoint:main']
      },
    )
    EOF
  '';

  preInstall = ''
    mkdir -p $out/{usr/share/boxflat,lib/udev/rules.d,share/icons}
    cp -r data "$out/usr/share/boxflat/"
    cp -r icons "$out/share/icons/hicolor"
    cp -r udev "$out/usr/share/boxflat"
    cp udev/99-boxflat.rules "$out/lib/udev/rules.d/"
  '';

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapperArgs+=(--add-flags "--data-path $out/usr/share/boxflat/data")
  '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "Boxflat";
      desktopName = name;
      genericName = "settings";
      comment = "Moza Racing settings app";
      exec = "boxflat";
      icon = "io.github.lawstorant.boxflat";
      startupWMClass = icon;
      startupNotify = true;
      categories = [
        "Game"
        "Utility"
      ];
      keywords = [
        "game"
        "racing"
        "cars"
        "wheels"
        "moza"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Lawstorant/boxflat";
    changelog = "https://github.com/Lawstorant/boxflat/releases/tag/v${finalAttrs.version}";
    description = "Control your Moza gear settings";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      racci
      vinso
    ];
    platforms = lib.platforms.linux;
    mainProgram = "boxflat";
  };
})
