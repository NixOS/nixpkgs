{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  lilypond,
  qt6,
}:

python3Packages.buildPythonApplication rec {
  pname = "frescobaldi";
  version = "4.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wbsoft";
    repo = "frescobaldi";
    tag = "v${version}";
    hash = "sha256-J0QC+VwNdA24vAW5Fx+cz5IFajkB8GmR4Rae0Q+2zw8=";
  };

  dependencies = with python3Packages; [
    qpageview
    lilypond
    pygame-ce
    pyqt6-sip
    python-ly
    pyqt6
    pyqt6-webengine
  ];

  buildInputs = [ qt6.qtbase ];
  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  build-system = with python3Packages; [
    hatchling
  ];

  # no tests in shipped with upstream
  doCheck = false;

  dontWrapQtApps = true;
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  meta = {
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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sepi ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/frescobaldi.x86_64-darwin
    mainProgram = "frescobaldi";
  };
}
