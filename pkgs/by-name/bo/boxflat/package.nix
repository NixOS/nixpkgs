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
}:

python3Packages.buildPythonPackage rec {
  pname = "boxflat";
  version = "1.27.1";

  src = fetchFromGitHub {
    owner = "Lawstorant";
    repo = "boxflat";
    tag = "v${version}";
    hash = "sha256-W+pnoSyTJS+ORb8vHX4QXOxkDskTb7X2cv6WyU3ctGQ=";
  };

  format = "setuptools";

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
  ];

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

  checkPhase = ''
    runHook preCheck
    runHook postCheck
  '';

  preInstall = ''
    mkdir -p $out/{usr/share/boxflat,lib/udev/rules.d,share/icons}
    cp -r data "$out/usr/share/boxflat/"
    cp -r icons $out/share/icons/hicolor
    cp udev/99-boxflat.rules "$out/lib/udev/rules.d/"
  '';

  postInstall = ''
    wrapProgram "$out/bin/boxflat" \
      --add-flags "--data-path $out/usr/share/boxflat/data"
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
    description = "Boxflat for Moza Racing. Control your Moza gear settings!";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ racci ];
    platforms = lib.platforms.linux;
    mainProgram = "boxflat";
  };
}
