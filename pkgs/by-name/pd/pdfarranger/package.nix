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
}:

python3Packages.buildPythonApplication rec {
  pname = "pdfarranger";
  version = "1.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pdfarranger";
    repo = "pdfarranger";
    tag = version;
    hash = "sha256-of1itPubf6LBJ4rSh1bca3yoNTiz5Qt9ar9XDe4nhxI=";
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
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  doCheck = false; # no tests

  meta = {
    inherit (src.meta) homepage;
    description = "Merge or split pdf documents and rotate, crop and rearrange their pages using a graphical interface";
    mainProgram = "pdfarranger";
    maintainers = with lib.maintainers; [
      symphorien
      endle
    ];
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/pdfarranger/pdfarranger/releases/tag/${src.tag}";
  };
}
