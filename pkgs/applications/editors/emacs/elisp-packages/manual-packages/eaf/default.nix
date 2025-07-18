{
  # Basic
  lib,
  melpaBuild,
  fetchFromGitHub,
  pkgs,
  callPackage,
  symlinkJoin,
  # Python dependency
  python3,
  # Updater
  unstableGitUpdater,
  # Sub-applications in the framework
  enabledApps,
}:

let

  eafApps = {
    eaf-pdf-viewer = callPackage ./apps/pdf-viewer { };
  };

  callApps = enabledApps eafApps;

  apps = builtins.map (item: item.app) callApps;
  appPythonDeps = builtins.map (item: item.pythonDeps) callApps;
  appOtherDeps = builtins.map (item: item.otherDeps) callApps;

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
  ] ++ appPythonDeps;
  pythonPkgs = ps: builtins.concatLists (builtins.map (f: f ps) pythonPackageLists);
  pythonEnv = python3.withPackages pythonPkgs;

  otherPackageLists = [
    (
      pkgs: with pkgs; [
        git
        nodejs
        wmctrl
        xdotool
      ]
    )
  ] ++ appOtherDeps;
  otherPkgs = builtins.concatLists (builtins.map (f: f pkgs) otherPackageLists);

  appsDrv = symlinkJoin {
    name = "emacs-application-framework-apps";
    paths = apps;
  };
  depsBin = symlinkJoin {
    name = "emacs-application-framework-deps-bin";
    paths = otherPkgs;
  };

in

melpaBuild (finalAttrs: {

  pname = "eaf";
  version = "0-unstable-2025-06-28";

  src = fetchFromGitHub {
    owner = "emacs-eaf";
    repo = "emacs-application-framework";
    rev = "6ff4e0fd24dc014737bee502058860c56cc7d8b2";
    hash = "sha256-Tc8VzTMy8Gn0aDkL8Ja0Xh3w7YGjsvJ6YikFCnTGUGw=";
  };

  postPatch = ''
    substituteInPlace eaf.el \
      --replace-fail "\"python3\"" \
                     "\"${pythonEnv.interpreter}\""
  '';

  files = ''
    ("*.el"
     "*.py"
     "applications.json"
     "core"
     "extension")
  '';

  postInstall = ''
    LISPDIR=$out/share/emacs/site-lisp/elpa/${finalAttrs.ename}-${finalAttrs.melpaVersion}
    cp -r "${appsDrv}/share/emacs/site-lisp/elpa/." \
          $LISPDIR/app/

    NATDIR=$out/share/emacs/native-lisp
    cp -r "${appsDrv}/share/emacs/native-lisp/." \
          $NATDIR/

    mkdir -p $out/bin/
    for item in ${depsBin}/bin/*; do
        ln -s $(readlink -mn $item) \
              $out/bin/$(basename $item)
    done
  '';

  # Workaround: some lisp files failed to compile
  ignoreCompilationError = true;

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
