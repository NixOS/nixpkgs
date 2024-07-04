{ buildPythonPackage
, lib
, fetchFromGitLab
, pyenchant
, scikit-learn
, pypillowfight
, pycountry
, whoosh
, termcolor
, pygobject3
, pyocr
, natsort
, libinsane
, distro
, openpaperwork-core
, openpaperwork-gtk
, psutil
, gtk3
, poppler_gi
, gettext
, which
, shared-mime-info
, libreoffice
, unittestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "paperwork-backend";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;
  format = "pyproject";

  sourceRoot = "${src.name}/paperwork-backend";

  patches = [
    # disables a flaky test https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/issues/1035#note_1493700
    ./flaky_test.patch
  ];

  patchFlags = [ "-p2" ];

  postPatch = ''
    chmod a+w -R ..
    patchShebangs ../tools
  '';

  propagatedBuildInputs = [
    distro
    gtk3
    libinsane
    natsort
    openpaperwork-core
    pyenchant
    pycountry
    pygobject3
    pyocr
    pypillowfight
    poppler_gi
    scikit-learn
    termcolor
    whoosh
  ];

  nativeBuildInputs = [
    gettext
    shared-mime-info
    which
    setuptools-scm
  ];

  preBuild = ''
    make l10n_compile
  '';

  nativeCheckInputs = [
    libreoffice
    openpaperwork-gtk
    psutil
    unittestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Backend part of Paperwork (Python API, no UI)";
    homepage = "https://openpaper.work";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aszlig symphorien ];
  };
}
