{
  lib,
  fetchFromGitHub,
  writeShellScriptBin,
  plover,

  wrapQtAppsHook ? qt6.wrapQtAppsHook,
  pkginfo ? python3Packages.pkginfo,
  packaging ? python3Packages.packaging,
  psutil ? python3Packages.psutil,
  pygments ? python3Packages.pygments,
  pyside6 ? python3Packages.pyside6,
  qtbase ? qt6.qtbase,
  readme-renderer ? python3Packages.readme-renderer,
  requests-cache ? python3Packages.requests-cache,
  requests-futures ? python3Packages.requests-futures,

  python3Packages,
  qt6,
}:

(plover.override {
  inherit wrapQtAppsHook;
}).overrideAttrs
  (oldAttrs: rec {
    version = "5.0.0.dev2";

    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = "plover";
      tag = "v${version}";
      hash = "sha256-PZwxVrdQPhgbj+YmWZIUETngeJGs6IQty0hY43tLQO0=";
    };

    # pythonRelaxDeps seemingly doesn't work here
    postPatch =
      oldAttrs.postPatch
      + ''
        sed -i /PySide6-Essentials/d pyproject.toml
      '';

    # Realistically this should be build-system and dependencies
    # and pname should be compared but it looks like buildPythonApplication
    # strips that info
    nativeBuildInputs =
      (lib.filter (package: package != python3Packages.pyqt5) oldAttrs.nativeBuildInputs)
      ++ [
        pyside6
        # Replacement for missing pyside6-essentials tools
        (writeShellScriptBin "pyside6-uic" ''
          exec ${qtbase}/libexec/uic -g python "$@"
        '')
        (writeShellScriptBin "pyside6-rcc" ''
          exec ${qtbase}/libexec/rcc -g python "$@"
        '')
      ];
    propagatedBuildInputs =
      (lib.filter (package: package != python3Packages.pyqt5) oldAttrs.propagatedBuildInputs)
      ++ [
        packaging
        pkginfo
        psutil
        pygments
        pyside6
        qtbase
        readme-renderer
        readme-renderer.optional-dependencies.md
        requests-cache
        requests-futures
      ];

    meta.description = oldAttrs.meta.description + " (Development version)";
  })
