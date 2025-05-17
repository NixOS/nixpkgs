{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  lilypond,
}:

python3Packages.buildPythonApplication rec {
  pname = "frescobaldi";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = "frescobaldi";
    tag = "v${version}";
    sha256 = "sha256-rbOV+K8k9B2XjqJaXapqa698W/P44LQ/f4pRNUx6Xcw=";
  };

  propagatedBuildInputs = with python3Packages; [
    qpageview
    lilypond
    pygame
    python-ly
    sip4
    pyqt5
    poppler-qt5
    pyqtwebengine
  ];

  nativeBuildInputs = [
    python3Packages.pyqtwebengine.wrapQtAppsHook
    python3Packages.tox
  ];

  # Needed because source is fetched from git
  preBuild = ''
    tox -e mo-generate
    tox -e linux-generate
  '';

  # no tests in shipped with upstream
  doCheck = false;

  dontWrapQtApps = true;
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  meta = with lib; {
    homepage = "https://frescobaldi.org/";
    description = "LilyPond sheet music text editor";
    longDescription = ''
      Powerful text editor with syntax highlighting and automatic completion,
      Music view with advanced Point & Click, Midi player to proof-listen
      LilyPond-generated MIDI files, Midi capturing to enter music,
      Powerful Score Wizard to quickly setup a music score, Snippet Manager
      to store and apply text snippets, templates or scripts, Use multiple
      versions of LilyPond, automatically selects the correct version, Built-in
      LilyPond documentation browser and built-in User Guide, Smart
      layout-control functions like coloring specific objects in the PDF,
      MusicXML import, Modern user iterface with configurable colors,
      fonts and keyboard shortcuts
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ sepi ];
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/frescobaldi.x86_64-darwin
    mainProgram = "frescobaldi";
  };
}
