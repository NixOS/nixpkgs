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
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = "auto-cpufreq";
    tag = "v${version}";
    hash = "sha256-DEs6jbWYJFJgpaPtF5NT3DQs3erjzdm2brLNHpjrEPA=";
  };

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
      --replace-fail "/opt/auto-cpufreq/override.pickle" "/var/run/override.pickle"
    substituteInPlace scripts/org.auto-cpufreq.pkexec.policy \
      --replace-fail "/opt/auto-cpufreq/venv/bin/auto-cpufreq" "$out/bin/auto-cpufreq"
    substituteInPlace auto_cpufreq/gui/app.py auto_cpufreq/gui/objects.py \
      --replace-fail "/usr/local/share/auto-cpufreq/images/icon.png" "$out/share/icons/hicolor/512x512/apps/auto-cpufreq.png"
    substituteInPlace auto_cpufreq/gui/app.py \
      --replace-fail "/usr/local/share/auto-cpufreq/scripts/style.css" "$out/share/auto-cpufreq/scripts/style.css"
  '';

  build-system = with python3Packages; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    click
    distro
    psutil
    pygobject3
    poetry-dynamic-versioning
    setuptools
    pyinotify
    urwid
    pyasyncore
    requests
  ];

  pythonRelaxDeps = [ "urwid" ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ getent ];

  postInstall =
    # copy script manually
    ''
      install -Dm 0755 scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq
    ''
    # copy css file
    + ''
      install -Dm 0644 scripts/style.css $out/share/auto-cpufreq/scripts/style.css
    ''
    # systemd service
    + ''
      install -Dm 0644 scripts/auto-cpufreq.service -t $out/lib/systemd/system
    ''
    # desktop icon
    + ''
      install -Dm 0644 scripts/auto-cpufreq-gtk.desktop -t $out/share/applications
      install -Dm 0644 images/icon.png $out/share/icons/hicolor/512x512/apps/auto-cpufreq.png
    ''
    # polkit policy
    + ''
      install -Dm 0644 scripts/org.auto-cpufreq.pkexec.policy -t $out/share/polkit-1/actions
    '';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  pythonImportsCheck = [ "auto_cpufreq" ];

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
