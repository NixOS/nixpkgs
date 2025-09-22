{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  dbus,
  doxygen,
  glib,
  libsForQt5,
  pkg-config,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buteo-syncfw";
  version = "0.11.10";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "sailfishos";
    repo = "buteo-syncfw";
    tag = finalAttrs.version;
    hash = "sha256-WZ70dFrQeHO0c9MM3wS8aWMd0DDhTW9Ks4hhw7pPmu8=";
  };

  postPatch = ''
    # Wildcard breaks file installation (tries to run ~ "install source/* target/*")
    substituteInPlace doc/doc.pri \
      --replace-fail 'htmldocs.files = $${PWD}/html/*' 'htmldocs.files = $${PWD}/html' \
      --replace-fail '/usr/share/doc' "$doc/share/doc"

    substituteInPlace declarative/declarative.pro \
      --replace-fail '$$[QT_INSTALL_QML]' "$out/${libsForQt5.qtbase.qtQmlPrefix}"

    substituteInPlace libbuteosyncfw/libbuteosyncfw.pro \
      --replace-fail '$$[QT_INSTALL_LIBS]' "$out/lib" \
      --replace-fail '/usr/include' "$dev/include"

    substituteInPlace msyncd/msyncd-app.pro \
      --replace-fail '/usr/bin' "$out/bin" \
      --replace-fail '/usr/lib/systemd' "$out/lib/systemd" \
      --replace-fail '/etc' "$out/etc" \
      --replace-fail '/usr/share' "$out/share"

    substituteInPlace oopp-runner/oopp-runner.pro \
      --replace-fail '/usr/libexec' "$out/libexec"

    # We don't have invoked (mapplauncherd)
    substituteInPlace msyncd/bin/msyncd.service \
      --replace-fail 'ExecStart=/usr/bin/invoker -G -o -s --type=qt5 /usr/bin/msyncd' "ExecStart=$out/bin/msyncd"

    substituteInPlace msyncd/com.meego.msyncd.service \
      --replace-fail 'Exec=/usr/bin/msyncd' "Exec=$out/bin/msyncd"

    # Tests expect to get installed, require excessive patching
    substituteInPlace buteo-sync.pro \
      --replace-fail 'unittests \' '\' \
      --replace-fail 'unittests.depends' '# unittests.depends'
  '';

  # QMake doesn't handle strictDeps well
  strictDeps = false;

  nativeBuildInputs = [
    doxygen
    glib
    pkg-config
    wrapGAppsHook3
  ]
  ++ (with libsForQt5; [
    qmake
    wrapQtAppsHook
  ]);

  buildInputs = [
    dbus
  ]
  ++ (with libsForQt5; [
    accounts-qt
    qtdeclarative
    signond
  ]);

  dontWrapGApps = true;

  # Do all configuring now, not during build
  postConfigure = ''
    make qmake_all
  '';

  # Tests expect to get installed, require excessive patching & managing
  doCheck = false;

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      # Version is hardcoded to 1.0.0
    };
  };

  meta = {
    description = "Buteo Synchronization Framework";
    homepage = "https://github.com/sailfishos/buteo-syncfw";
    changelog = "https://github.com/sailfishos/buteo-syncfw/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl21Only;
    mainProgram = "msyncd";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "buteosyncfw5"
    ];
  };
})
