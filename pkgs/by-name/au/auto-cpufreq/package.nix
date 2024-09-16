{
  lib,
  python3Packages,
  fetchFromGitHub,
  substituteAll,
  gobject-introspection,
  wrapGAppsHook3,
  gtk3,
}:
python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "2.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = "auto-cpufreq";
    rev = "refs/tags/v${version}";
    hash = "sha256-Xsh3d7rQY7RKzZ7J0swrgxZEyITb7B3oX5F/tcBGjfk=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    python3Packages.poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    distro
    psutil
    pygobject3
    poetry-dynamic-versioning
    setuptools
    pyinotify
  ];

  doCheck = false;
  pythonImportsCheck = [ "auto_cpufreq" ];

  patches = [
    # hardcodes version output
    (substituteAll {
      src = ./fix-version-output.patch;
      inherit version;
    })

    # patch to prevent script copying and to disable install
    ./prevent-install-and-copy.patch
    # patch to prevent update
    ./prevent-update.patch
  ];

  postPatch = ''
    substituteInPlace auto_cpufreq/core.py \
      --replace-fail '/opt/auto-cpufreq/override.pickle' /var/run/override.pickle
    substituteInPlace scripts/org.auto-cpufreq.pkexec.policy \
      --replace-fail "/opt/auto-cpufreq/venv/bin/auto-cpufreq" $out/bin/auto-cpufreq
    substituteInPlace auto_cpufreq/gui/app.py auto_cpufreq/gui/objects.py \
      --replace-fail "/usr/local/share/auto-cpufreq/images/icon.png" $out/share/pixmaps/auto-cpufreq.png
    substituteInPlace auto_cpufreq/gui/app.py \
      --replace-fail "/usr/local/share/auto-cpufreq/scripts/style.css" $out/share/auto-cpufreq/scripts/style.css
  '';

  postInstall = ''
    # copy script manually
    cp ${src}/scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq

    # copy css file
    mkdir -p $out/share/auto-cpufreq/scripts
    cp scripts/style.css $out/share/auto-cpufreq/scripts/style.css

    # systemd service
    mkdir -p $out/lib/systemd/system
    cp ${src}/scripts/auto-cpufreq.service $out/lib/systemd/system

    # desktop icon
    mkdir -p $out/share/applications
    mkdir $out/share/pixmaps
    cp scripts/auto-cpufreq-gtk.desktop $out/share/applications
    cp images/icon.png $out/share/pixmaps/auto-cpufreq.python3Packages

    # polkit policy
    mkdir -p $out/share/polkit-1/actions
    cp scripts/org.auto-cpufreq.pkexec.policy $out/share/polkit-1/actions
  '';

  meta = {
    mainProgram = "auto-cpufreq";
    homepage = "https://github.com/AdnanHodzic/auto-cpufreq";
    description = "Automatic CPU speed & power optimizer for Linux";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
  };
}
