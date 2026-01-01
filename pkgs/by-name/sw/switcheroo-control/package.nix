{
  lib,
  ninja,
  meson,
  fetchFromGitLab,
  systemd,
<<<<<<< HEAD
  libdrm,
  libgudev,
  pkg-config,
  wrapGAppsNoGuiHook,
=======
  libgudev,
  pkg-config,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  glib,
  python3Packages,
}:

<<<<<<< HEAD
let
  version = "3.0";
in
python3Packages.buildPythonApplication {
  pname = "switcheroo-control";
  inherit version;
  pyproject = false;
=======
python3Packages.buildPythonApplication rec {
  pname = "switcheroo-control";
  version = "2.6";

  format = "other";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "hadess";
    repo = "switcheroo-control";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-7P0o8fBYe4izRmNL7DimUSJfzj13KXW9we6c/A2iNo8=";
  };

  postPatch = ''
    substituteInPlace data/meson.build \
      --replace-fail "rules_dir" "'${placeholder "out"}/lib/udev/rules.d'"
  '';

=======
    rev = version;
    hash = "sha256-F+5HhMxM8pcnAGmVBARKWNCL0rIEzHW/jsGHHqYZJug=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    ninja
    meson
    pkg-config
<<<<<<< HEAD
    wrapGAppsNoGuiHook
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    systemd
<<<<<<< HEAD
    libdrm
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libgudev
    glib
  ];

<<<<<<< HEAD
  dependencies = [
=======
  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    python3Packages.pygobject3
  ];

  mesonFlags = [
    "-Dsystemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dhwdbdir=${placeholder "out"}/etc/udev/hwdb.d"
  ];

<<<<<<< HEAD
  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
