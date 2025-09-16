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

python3Packages.buildPythonPackage rec {
  pname = "boxflat";
  version = "1.34.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Lawstorant";
    repo = "boxflat";
    tag = "v${version}";
    hash = "sha256-QuBGEOAMVR70JDpD1VVASuCJJdwbWDzK8qmo/BOOua0=";
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
  ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook4
    gobject-introspection
    udevCheckHook
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
        --replace-fail "psutil==6.1.0" "psutil" \
        --replace-fail "evdev==1.7.1" "evdev" \
        --replace-fail "pycairo==1.27.0" "pycairo"
  '';

  preBuild = ''
    cat > setup.py << EOF
    import shutil
    from setuptools import setup

    with open('requirements.txt') as f:
        install_requires = f.read().splitlines()

    shutil.copyfile('entrypoint.py', 'boxflat/entrypoint.py')

    setup(
      name='boxflat',
      packages=['boxflat', 'boxflat.panels', 'boxflat.widgets'],
      version='${version}',
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
    changelog = "https://github.com/Lawstorant/boxflat/releases/tag/v${version}";
    description = "Control your Moza gear settings";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ racci ];
    platforms = lib.platforms.linux;
    mainProgram = "boxflat";
  };
}
