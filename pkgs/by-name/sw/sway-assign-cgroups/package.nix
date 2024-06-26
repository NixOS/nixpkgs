{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "sway-assign-cgroups";
  version = "0.4.0";
  src = fetchFromGitHub {
    owner = "alebastr";
    repo = "sway-systemd";
    rev = "v${version}";
    sha256 = "sha256-wznYE1/lVJtvf5Nq96gbPYisxc2gWLahVydwcH1vwoQ=";
  };
  format = "other";

  propagatedBuildInputs = with python3Packages; [
    dbus-next
    i3ipc
    psutil
    tenacity
    xlib
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/assign-cgroups.py $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Place GUI applications into systemd scopes for systemd-oomd compatibility";
    mainProgram = "assign-cgroups.py";
    longDescription = ''
      Automatically assign a dedicated systemd scope to the GUI applications
      launched in the same cgroup as the compositor. This could be helpful for
      implementing cgroup-based resource management and would be necessary when
      `systemd-oomd` is in use.

      Limitations: The script is using i3ipc window:new event to detect application
      launches and would fail to detect background apps or special surfaces.
      Therefore it's recommended to supplement the script with use of systemd user
      services for such background apps.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickhu ];
  };
}
