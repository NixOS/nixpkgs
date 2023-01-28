{ buildPythonPackage
, lib
, fetchFromGitLab

, isPy3k
, isPyPy

, openpaperwork-core
, openpaperwork-gtk
, paperwork-backend
, fabulous
, getkey
, psutil

, pkgs
}:

buildPythonPackage rec {
  pname = "paperwork-shell";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;

  sourceRoot = "source/paperwork-shell";

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  patchPhase = ''
    echo 'version = "${version}"' > src/paperwork_shell/_version.py
    chmod a+w -R ..
    patchShebangs ../tools
  '';

  propagatedBuildInputs = [
    openpaperwork-core
    paperwork-backend
    fabulous
    getkey
    psutil
  ];

  nativeCheckInputs = [
    openpaperwork-gtk
  ];

  nativeBuildInputs = [ pkgs.gettext pkgs.which ];
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
    maintainers = with lib.maintainers; [ aszlig symphorien ];
  };
}
