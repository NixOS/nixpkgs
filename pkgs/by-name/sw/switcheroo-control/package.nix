{
  lib,
  ninja,
  meson,
  fetchFromGitLab,
  systemd,
  libgudev,
  pkg-config,
  glib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "switcheroo-control";
  version = "2.6";

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "switcheroo-control";
    rev = version;
    hash = "sha256-F+5HhMxM8pcnAGmVBARKWNCL0rIEzHW/jsGHHqYZJug=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
  ];

  buildInputs = [
    systemd
    libgudev
    glib
  ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dhwdbdir=${placeholder "out"}/etc/udev/hwdb.d"
  ];

  meta = {
    description = "D-Bus service to check the availability of dual-GPU";
    mainProgram = "switcherooctl";
    homepage = "https://gitlab.freedesktop.org/hadess/switcheroo-control/";
    changelog = "https://gitlab.freedesktop.org/hadess/switcheroo-control/-/blob/${version}/NEWS";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
