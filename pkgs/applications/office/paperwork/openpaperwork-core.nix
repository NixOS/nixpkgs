{ buildPythonPackage, lib, fetchFromGitLab

, isPy3k, isPyPy

, distro, setuptools, psutil

, pkgs
}:

buildPythonPackage rec {
  pname = "openpaperwork-core";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;

  sourceRoot = "source/openpaperwork-core";

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  patchPhase = ''
    echo 'version = "${version}"' > src/openpaperwork_core/_version.py
    chmod a+w -R ..
    patchShebangs ../tools
  '';

  propagatedBuildInputs = [
    distro
    setuptools
    psutil
  ];

  nativeBuildInputs = [ pkgs.gettext pkgs.which ];

  preBuild = ''
    make l10n_compile
  '';

  meta = {
    description = "Backend part of Paperwork (Python API, no UI)";
    homepage = "https://openpaper.work/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aszlig symphorien ];
    platforms = lib.platforms.linux;
  };
}
