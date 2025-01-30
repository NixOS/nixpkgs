{
  lib,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  gobject-introspection,
  wrapGAppsHook3,
  gtk3,
  getent,
  nixosTests,
}:
python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "2.5.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = "auto-cpufreq";
    tag = "v${version}";
    hash = "sha256-iDvgL5dQerQnu2ERKAWGvWppG7cQ/0uKEfVY93ItvO4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    python3Packages.poetry-core
  ];

  propagatedBuildInputs =
    with python3Packages;
    [
      click
      distro
      psutil
      pygobject3
      poetry-dynamic-versioning
      setuptools
      pyinotify
    ]
    ++ [ getent ];

  doCheck = false;
  pythonImportsCheck = [ "auto_cpufreq" ];

  patches = [
    # hardcodes version output
    (replaceVars ./fix-version-output.patch {
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
    cp images/icon.png $out/share/pixmaps/auto-cpufreq.png

    # polkit policy
    mkdir -p $out/share/polkit-1/actions
    cp scripts/org.auto-cpufreq.pkexec.policy $out/share/polkit-1/actions
  '';

  passthru.tests = {
    inherit (nixosTests) auto-cpufreq;
  };

  meta = {
    mainProgram = "auto-cpufreq";
    homepage = "https://github.com/AdnanHodzic/auto-cpufreq";
    description = "Automatic CPU speed & power optimizer for Linux";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
  };
}
