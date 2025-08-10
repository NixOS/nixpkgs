{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  symlinkJoin,
  # Python dependency
  python3,
  # Emacs dependencies
  all-the-icons,
  # Other dependencies
  git,
  nodejs,
  wmctrl,
  xdotool,
  # Updater
  unstableGitUpdater,
  # Sub-applications in the framework
  enabledApps ? [ ],
}:

let

  appPythonDeps = builtins.map (item: item.eafPythonDeps) enabledApps;
  appOtherDeps = builtins.map (item: item.eafOtherDeps) enabledApps;

  pythonPackageLists = [
    (
      ps: with ps; [
        epc
        lxml
        pyqt6
        pyqt6-sip
        pyqt6-webengine
        sexpdata
        tld
      ]
    )
  ]
  ++ appPythonDeps;
  pythonPkgs = ps: builtins.concatLists (builtins.map (f: f ps) pythonPackageLists);
  pythonEnv = python3.withPackages pythonPkgs;

  otherPackageLists = [
    [
      git
      nodejs
      wmctrl
      xdotool
    ]
  ]
  ++ appOtherDeps;
  otherPkgs = builtins.concatLists (otherPackageLists);

  appsDrv = symlinkJoin {
    name = "emacs-application-framework-apps";
    paths = enabledApps;
  };
  depsBin = symlinkJoin {
    name = "emacs-application-framework-deps-bin";
    paths = otherPkgs;
  };

in

melpaBuild (finalAttrs: {

  pname = "eaf";
  version = "0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "emacs-application-framework";
    rev = "f7431199fb3143f4487213b7ea6a16a3d037b2ff";
    hash = "sha256-qpaLizkxuOKd/9kfym3+xAssVm+sV3IlxLCApv+yUz8=";
  };

  packageRequires = [
    all-the-icons
  ];

  postPatch = ''
    substituteInPlace eaf.el \
      --replace-fail "\"python.exe\" \"python3\"" \
                     "\"python.exe\" \"${pythonEnv.interpreter}\""
  '';

  files = ''
    ("*.el"
     "*.py"
     "applications.json"
     "core"
     "extension")
  '';

  preInstall = ''
    EMACSLOADPATH="$EMACSLOADPATH:core/"
  '';

  postInstall = ''
    LISPDIR=$out/share/emacs/site-lisp/elpa/${finalAttrs.ename}-${finalAttrs.melpaVersion}
    APPLISPDIR=${appsDrv}/share/emacs/site-lisp/elpa
    if [ -d $APPLISPDIR ]; then
      cp -r $APPLISPDIR/. \
            $LISPDIR/app/
    fi

    NATDIR=$out/share/emacs/native-lisp
    APPNATDIR=${appsDrv}/share/emacs/native-lisp
    if [ -d $APPNATDIR ]; then
      cp -r $APPNATDIR/. \
            $NATDIR/
    fi

    mkdir -p $out/bin/
    for item in ${depsBin}/bin/*; do
      # Some symbolic links point to another symbolic link
      ln -s $(readlink -f $item) \
            $out/bin/$(basename $item)
    done
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Extensible framework of Emacs";
    homepage = "https://github.com/emacs-eaf/emacs-application-framework";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      thattemperature
    ];
  };

})
