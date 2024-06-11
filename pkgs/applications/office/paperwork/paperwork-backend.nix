{ buildPythonPackage
, lib
, fetchFromGitLab
, fetchpatch
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
    # fixes building with recent scipy
    # remove on next release
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/commit/abcebfe9714644d4e259e53b10e0e9417b5b864f.patch";
      hash = "sha256-YjVpphThW5Livs+PZJZDSgJvhLSXhZ1bnlWMwfY4HTg=";
    })

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
