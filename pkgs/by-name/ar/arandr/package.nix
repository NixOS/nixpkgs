{
  lib,
  fetchFromGitLab,
  fetchpatch,
  python3Packages,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk3,
  wrapGAppsHook3,
  xrandr,
  nix-update-script,
}:

let
  inherit (python3Packages)
    buildPythonApplication
    setuptools
    docutils
    pygobject3
    ;
in
buildPythonApplication (finalAttrs: {
  pname = "arandr";
  version = "debian/0.1.11-1";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "arandr";
    repo = "arandr";
    tag = finalAttrs.version;
    hash = "sha256-KAnTo3+0WTB1SzMCM8vDMPJhPw/fsT4msRETXwE21qA=";
  };

  patches = [
    # patch to set mtime=0 on setup.py
    ./gzip-timestamp-fix.patch

    # fixes build with setuptools 81+, while keeping it backwards compatible
    (fetchpatch {
      name = "arandr-0.1.11-setuptools-81.patch";
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/x11-misc/arandr/files/arandr-0.1.11-setuptools-81.patch";
      hash = "sha256-b9U8b4rdkN5lWDVpv50szaVS0rAZVSy7q6IXNVLvq3A=";
    })
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
  ];

  build-system = [ setuptools ];

  dependencies = [
    docutils
    pygobject3
  ];

  preBuild = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  dontWrapGApps = true;

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ xrandr ])
    "\${gappsWrapperArgs[@]}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=(\\d.*)"
    ];
  };

  meta = {
    changelog = "https://gitlab.com/arandr/arandr/-/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Simple visual front end for XRandR";
    homepage = "https://christian.amsuess.com/tools/arandr/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "arandr";
    maintainers = with lib.maintainers; [
      gepbird
    ];
  };
})
