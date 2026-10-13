{
  fetchFromGitHub,
  lib,
  wrapGAppsHook3,
  python3Packages,
  gtk3,
  poppler_gi,
  libhandy,
  gettext,
  stdenv,
  runCommand,
  xvfb-run,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pdfarranger";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdfarranger";
    repo = "pdfarranger";
    tag = finalAttrs.version;
    hash = "sha256-vucl04ltyAFUhwGlFfNnLEyvX2SACEt0WCG3t4QLuxc=";
  };

  nativeBuildInputs = [ wrapGAppsHook3 ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ gettext ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    LINTL="${lib.getLib gettext}/lib/libintl.8.dylib"
    substituteInPlace pdfarranger/pdfarranger.py --replace-fail \
      "return 'libintl.8.dylib'" \
      "return '$LINTL'"
    unset LINTL
  '';

  build-system = with python3Packages; [ setuptools ];

  buildInputs = [
    gtk3
    poppler_gi
    libhandy
  ];

  dependencies = with python3Packages; [
    pygobject3
    pikepdf
    img2pdf
    setuptools
    python-dateutil
  ];

  # incompatible with wrapGAppsHook3
  strictDeps = false;
  dontWrapGApps = true;
  makeWrapperArgs = [
    "\${gappsWrapperArgs[@]}"
    "--unset PYTHONPATH"
    "--unset PYTHONHOME"
  ];

  doCheck = false; # no tests

  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    python-environment =
      runCommand "pdfarranger-python-environment"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            xvfb-run
          ];
          meta.timeout = 60;
        }
        ''
          HOME=$(mktemp -d)
          export HOME
          mkdir foreign-python
          echo 'raise RuntimeError("Imported pikepdf from the inherited Python environment")' > foreign-python/pikepdf.py

          xvfb-run -a pdfarranger --help | grep -F -- '--version'
          for variable in PYTHONPATH PYTHONHOME; do
            env "$variable=$PWD/foreign-python" xvfb-run -a pdfarranger --help \
              | grep -F -- '--version'
          done

          touch "$out"
        '';
  };

  meta = {
    inherit (finalAttrs.src.meta) homepage;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages using a graphical interface";
    mainProgram = "pdfarranger";
    maintainers = with lib.maintainers; [
      symphorien
      endle
    ];
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/pdfarranger/pdfarranger/releases/tag/${finalAttrs.src.tag}";
  };
})
