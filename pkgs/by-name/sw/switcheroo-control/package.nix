{
  lib,
  ninja,
  meson,
  fetchFromGitLab,
  systemd,
  libdrm,
  libgudev,
  pkg-config,
  wrapGAppsNoGuiHook,
  glib,
  python3Packages,
}:

let
  version = "3.0";
in
python3Packages.buildPythonApplication {
  pname = "switcheroo-control";
  inherit version;
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "switcheroo-control";
    tag = version;
    hash = "sha256-7P0o8fBYe4izRmNL7DimUSJfzj13KXW9we6c/A2iNo8=";
  };

  postPatch = ''
    substituteInPlace data/meson.build \
      --replace-fail "rules_dir" "'${placeholder "out"}/lib/udev/rules.d'"
  '';

  nativeBuildInputs = [
    ninja
    meson
    pkg-config
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    systemd
    libdrm
    libgudev
    glib
  ];

  dependencies = [
    python3Packages.pygobject3
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dhwdbdir=${placeholder "out"}/etc/udev/hwdb.d"
  ];

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

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
