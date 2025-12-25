{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  lilypond,
}:

python3Packages.buildPythonApplication rec {
  pname = "frescobaldi";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frescobaldi";
    repo = "frescobaldi";
    tag = "v${version}";
    hash = "sha256-fTTHhoQJUOYncYkKb9jwp9i0hCoQpClvVlil/A6r8UI=";
  };

  dependencies = with python3Packages; [
    qpageview
    lilypond
    pyqt6
    pyqt6-webengine
    python-ly
  ];

  build-system = [ python3Packages.hatchling ];

  nativeBuildInputs = with python3Packages; [
    pyqtwebengine.wrapQtAppsHook
    tox
    pygame-ce
  ];

  # Needed because source is fetched from git
  preBuild = ''
    tox -e mo-generate
    tox -e linux-generate
  '';

  # Needed otherwise hatchling complains that the license has both file and text even though it doesn't
  postPatch = "sed -i '/license = {text =/d' pyproject.toml";

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
