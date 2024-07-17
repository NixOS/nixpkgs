{
  lib,
  zlib,
  fetchFromGitHub,
  python3Packages,
  wrapQtAppsHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "manuskript";
  version = "0.16.1";

  format = "other";

  src = fetchFromGitHub {
    repo = pname;
    owner = "olivierkes";
    rev = "refs/tags/${version}";
    hash = "sha256-/Ryvv5mHdZ3iwMpZjOa62h8D2B00pzknJ70DfjDTPPA=";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = [
    python3Packages.pyqt5
    python3Packages.lxml
    zlib
  ];

  patchPhase = ''
    substituteInPlace manuskript/ui/welcome.py \
      --replace sample-projects $out/share/${pname}/sample-projects
  '';

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/share/${pname}
    cp -av  bin/ i18n/ libs/ manuskript/ resources/ icons/ $out
    cp -r sample-projects/ $out/share/${pname}
  '';

  postFixup = ''
    wrapQtApp $out/bin/manuskript
  '';

  doCheck = false;

  meta = {
    description = "A open-source tool for writers";
    homepage = "https://www.theologeek.ch/manuskript";
    longDescription = ''
      Manuskript is a tool for those writer who like to organize and
      plan everything before writing.  The snowflake method can help you
      grow your idea into a book, by leading you step by step and asking
      you questions to go deeper. While writing, keep track of notes
      about every characters, plot, event, place in your story.

      Develop complex characters and keep track of all useful infos.
      Create intricate plots, linked to your characters, and use them to
      outline your story. Organize your ideas about the world your
      characters live in.
    '';
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "manuskript";
  };
}
