{
  lib,
  ninja,
  meson,
  libdrm,
  fetchFromGitLab,
  systemd,
  libgudev,
  pkg-config,
  glib,
  python3Packages,
  wrapGAppsNoGuiHook,
}:

let
  version = "3.0";
in
python3Packages.buildPythonApplication {
  pname = "switcheroo-control";
  inherit version;

  format = "other";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "switcheroo-control";
    tag = version;
    hash = "sha256-7P0o8fBYe4izRmNL7DimUSJfzj13KXW9we6c/A2iNo8=";
  };

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    wrapGAppsNoGuiHook
  ];

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  buildInputs = [
    systemd
    libdrm
    libgudev
    glib
  ];

  propagatedBuildInputs = [
    python3Packages.pygobject3
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dhwdbdir=${placeholder "out"}/etc/udev/hwdb.d"
    "-Drulesdir=${placeholder "out"}/lib/udev/rules.d"
  ];

  meta = with lib; {
    description = "D-Bus service to check the availability of dual-GPU";
    mainProgram = "switcherooctl";
    homepage = "https://gitlab.freedesktop.org/hadess/switcheroo-control/";
    changelog = "https://gitlab.freedesktop.org/hadess/switcheroo-control/-/blob/${version}/NEWS";
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [ caniko ];
    platforms = platforms.linux;
  };
}
