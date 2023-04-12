{ buildPythonPackage
, lib
, fetchFromGitLab

, isPy3k
, isPyPy

, openpaperwork-core
, pillow
, pygobject3
, distro

, pkgs
}:

buildPythonPackage rec {
  pname = "openpaperwork-gtk";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;

  sourceRoot = "source/openpaperwork-gtk";

  # Python 2.x is not supported.
  disabled = !isPy3k && !isPyPy;

  patchPhase = ''
    echo 'version = "${version}"' > src/openpaperwork_gtk/_version.py
    chmod a+w -R ..
    patchShebangs ../tools
  '';

  nativeBuildInputs = [ pkgs.gettext pkgs.which ];
  preBuild = ''
    make l10n_compile
  '';

  propagatedBuildInputs = [
    pillow
    pygobject3
    pkgs.poppler_gi
    pkgs.gtk3
    pkgs.libhandy
    distro
    pkgs.pango
    openpaperwork-core
  ];

  meta = {
    description = "Reusable GTK components of Paperwork";
    homepage = "https://openpaper.work/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aszlig symphorien ];
    platforms = lib.platforms.linux;
  };
}
