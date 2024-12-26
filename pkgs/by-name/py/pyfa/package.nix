{
  lib,
  python3Packages,
  fetchFromGitHub,
  gsettings-desktop-schemas,
  adwaita-icon-theme,
  wrapGAppsHook3,
  gdk-pixbuf,
}:
let
  version = "2.61.3";
in
python3Packages.buildPythonApplication rec {
  inherit version;
  pname = "pyfa";
  format = "other";

  src = fetchFromGitHub {
    owner = "pyfa-org";
    repo = "Pyfa";
    rev = "refs/tags/v${version}";
    hash = "sha256-i8NcRTn817gqwQP6j0RPUJkq09eTI4nfe3EVqYnWRpo=";
  };

  build-system = [ python3Packages.setuptools ];
  dependencies = with python3Packages; [
    wxpython
    logbook
    matplotlib
    python-dateutil
    requests
    sqlalchemy_1_4
    cryptography
    markdown2
    beautifulsoup4
    pyaml
    roman
    numpy
    python-jose
    requests-cache
  ];

  buildInputs = [
    gsettings-desktop-schemas
    adwaita-icon-theme
    gdk-pixbuf
  ];

  dontWrapGApps = true;
  nativeBuildInputs = [
    python3Packages.pyinstaller
    wrapGAppsHook3
  ];

  #
  # upstream does not include setup.py
  #
  patchPhase = ''
    cat > setup.py <<EOF
      from setuptools import setup
      setup(
        name = "${pname}",
        version = "${version}",
        scripts = ["pyfa.py"],
        packages = setuptools.find_packages(),
      )
    EOF
  '';

  configurePhase = ''
    runHook preConfigure

    python3 db_update.py

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pyinstaller --clean --noconfirm pyfa.spec

    runHook postBuild
  '';

  #
  # pyinstaller builds up dist/pyfa/pyfa binary and
  # dist/pyfa/apps directory with libraries and everything else.
  # creating a symbolic link out in $out/bin to $out/share/pyfa to avoid
  # exposing the innards of pyfa to the rest of the env.
  #
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/pixmaps

    cp -r dist/pyfa $out/share/
    cp imgs/gui/pyfa64.png $out/share/pixmaps/pyfa.png
    ln -sf $out/share/pyfa/pyfa $out/bin/pyfa
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgramShell $out/share/pyfa/pyfa \
      ''${gappsWrapperArgs[@]} \

    runHook postFixup
  '';

  doCheck = true;

  meta = {
    description = "Python fitting assistant, cross-platform fitting tool for EVE Online";
    homepage = "https://github.com/pyfa-org/Pyfa";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      toasteruwu
      cholli
      paschoal
    ];
    mainProgram = "pyfa";
    platforms = lib.platforms.linux;
  };
}
