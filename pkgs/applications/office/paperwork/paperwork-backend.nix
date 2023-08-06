{ buildPythonPackage
, lib
, fetchpatch
, fetchFromGitLab
, pyenchant
, scikit-learn
, pypillowfight
, pycountry
, whoosh
, termcolor
, levenshtein
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
}:

buildPythonPackage rec {
  pname = "paperwork-backend";
  inherit (import ./src.nix { inherit fetchFromGitLab; }) version src;

  sourceRoot = "${src.name}/paperwork-backend";

  patches = [
    # disables a flaky test https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/issues/1035#note_1493700
    ./flaky_test.patch
    (fetchpatch {
      url = "https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/commit/0f5cf0fe7ef223000e02c28e4c7576f74a778fe6.patch";
      hash = "sha256-NIK3j2TdydfeK3/udS/Pc+tJa/pPkfAmSPPeaYuaCq4=";
    })
  ];

  patchFlags = [ "-p2" ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace python-Levenshtein Levenshtein

    echo 'version = "${version}"' > src/paperwork_backend/_version.py
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
    levenshtein
    poppler_gi
    scikit-learn
    termcolor
    whoosh
  ];

  nativeBuildInputs = [
    gettext
    shared-mime-info
    which
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
