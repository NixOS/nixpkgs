{ buildPythonPackage
, lib
, fetchFromGitLab

, isPy3k
, isPyPy

, distro
, setuptools
, psutil
, certifi
, setuptools-scm

, pkgs
}:

buildPythonPackage rec {
  pname = "openpaperwork-core";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;
  format = "pyproject";

  sourceRoot = "${src.name}/openpaperwork-core";

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  patchPhase = ''
    chmod a+w -R ..
    patchShebangs ../tools
  '';

  propagatedBuildInputs = [
    distro
    setuptools
    psutil
    certifi
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
  '';

  meta = {
    description = "Backend part of Paperwork (Python API, no UI)";
    homepage = "https://openpaper.work/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aszlig symphorien ];
    platforms = lib.platforms.linux;
  };
}
