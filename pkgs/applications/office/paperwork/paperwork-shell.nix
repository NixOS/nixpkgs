{
  buildPythonPackage,
  lib,
  fetchFromGitLab,

  isPy3k,
  isPyPy,

  openpaperwork-core,
  openpaperwork-gtk,
  paperwork-backend,
  fabulous,
  rich,
  getkey,
  psutil,
  shared-mime-info,
  setuptools-scm,

  pkgs,
}:

buildPythonPackage rec {
  pname = "paperwork-shell";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;
  format = "pyproject";

  sourceRoot = "${src.name}/paperwork-shell";

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  patchPhase = ''
    chmod a+w -R ..
    patchShebangs ../tools
  '';
  propagatedBuildInputs = [
    openpaperwork-core
    paperwork-backend
    fabulous
    getkey
    psutil
    rich
  ];

  nativeCheckInputs = [
    shared-mime-info
    openpaperwork-gtk
  ];

  nativeBuildInputs = [
    pkgs.gettext
    pkgs.which
    setuptools-scm
  ];

  preBuild = ''
    make l10n_compile
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
    "$out/bin/paperwork-cli" chkdeps
  '';

  meta = {
    description = "CLI for Paperwork";
    homepage = "https://openpaper.work/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aszlig
      symphorien
    ];
  };
}
