{
  lib,
  python3,
  meson,
  ninja,
  stdenv,
  fetchFromGitHub,
  xdg-dbus-proxy,
  bubblewrap,
  libseccomp,
  libnotify,
  desktop-file-utils,
  scdoc,
}:
stdenv.mkDerivation rec {
  pname = "bubblejail";
  version = "0.9.4.1";

  src = fetchFromGitHub {
    owner = "igo95862";
    repo = "bubblejail";
    tag = version;
    hash = "sha256-zQuNS26FgQpjVmjzNjw/tHP/H2rs53jqNlYZR3kqfzU=";
  };

  patches = [
    ../../../development/python-modules/bubblejail/scan-store.patch
    ../../../development/python-modules/bubblejail/env-python.patch
    ../../../development/python-modules/bubblejail/meson-options.patch
  ];

  buildInputs = with python3.pkgs; [
    xdg-dbus-proxy
    bubblewrap
    libseccomp
    libnotify
    desktop-file-utils

    # python deps
    pyxdg
    tomli-w
    pyqt6
    lxns
    bubblejail
  ];

  nativeBuildInputs = [
    # scdoc
    python3.pkgs.jinja2
    meson
    ninja
    python3
  ];

  meta = {
    description = "Bubblewrap based sandboxing for desktop applications";
    homepage = "https://github.com/igo95862/bubblejail/";
    changelog = "https://github.com/igo95862/bubblejail/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [justdeeevin];
    mainProgram = "bubblejail";
  };
}
