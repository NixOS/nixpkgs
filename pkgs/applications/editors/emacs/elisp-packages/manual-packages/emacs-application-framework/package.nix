{
  # Basic
  stdenv,
  lib,
  melpaBuild,
  fetchFromGitHub,
  symlinkJoin,
  # Python dependency
  python3,
  # Emacs dependencies
  all-the-icons,
  # Other dependencies
  wmctrl,
  xdotool,
  # Updater
  unstableGitUpdater,
  # Sub-applications in the framework
  enabledApps ? [ ],
}:

let

  appPythonDeps = map (item: item.eafPythonDeps) enabledApps;

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
  pythonPkgs = ps: builtins.concatLists (map (f: f ps) pythonPackageLists);
  pythonEnv = python3.withPackages pythonPkgs;

  wmctrlExe = lib.getExe wmctrl;
  xdotoolExe = lib.optionalString (lib.meta.availableOn stdenv.hostPlatform xdotool) (
    lib.getExe xdotool
  );

  appsDrv = symlinkJoin {
    name = "emacs-application-framework-apps";
    paths = enabledApps;
  };

in

melpaBuild (finalAttrs: {

  pname = "eaf";
  version = "0-unstable-2025-08-22";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "emacs-application-framework";
    rev = "dc5f6e7fa21a15b5e05c7722c2b8f32158aeab82";
    hash = "sha256-wWC5Ma9p/k0GLcGpPn7NO0KqkIXmEbaQc7TJ2ImMIr4=";
  };

  packageRequires = [
    all-the-icons
  ];

  postPatch = ''
    substituteInPlace eaf.el \
      --replace-fail "\"python.exe\" \"python3\"" \
                     "\"python.exe\" \"${pythonEnv.interpreter}\""

    substituteInPlace eaf.el \
      --replace-fail "(executable-find \"wmctrl\")" \
                     "(executable-find \"${wmctrlExe}\")" \
      --replace-fail "(shell-command-to-string \"wmctrl -m\")" \
                     "(shell-command-to-string \"${wmctrlExe} -m\")" \
      --replace-fail "\"wmctrl -i -a \$(wmctrl -lp | awk -vpid=\$PID '\$3==%s {print \$1; exit}')\"" \
                     "\"${wmctrlExe} -i -a \$(${wmctrlExe} -lp | awk -vpid=\$PID '\$3==%s {print \$1; exit}')\""

    substituteInPlace eaf.el \
      --replace-fail "(executable-find \"xdotool\")" \
                     "(executable-find \"${xdotoolExe}\")" \
      --replace-fail "(shell-command-to-string \"xdotool getactivewindow getwindowname\")" \
                     "(shell-command-to-string \"${xdotoolExe} getactivewindow getwindowname\")"
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
