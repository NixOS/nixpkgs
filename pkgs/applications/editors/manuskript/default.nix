{
  lib,
  zlib,
  fetchFromGitHub,
  python3Packages,
  wrapQtAppsHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "manuskript";
  version = "0.17.0";

  format = "other";

  src = fetchFromGitHub {
    repo = "manuskript";
    owner = "olivierkes";
    tag = version;
    hash = "sha256-jOhbN6lMx04q60S0VOABmSNE/x9Er9exFYvWJe2INlE=";
  };

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = [
    python3Packages.pyqt5
    python3Packages.lxml
    zlib
  ];

  patchPhase = ''
    substituteInPlace manuskript/ui/welcome.py \
      --replace sample-projects $out/share/manuskript/sample-projects
  '';

  buildPhase = "";

  installPhase = ''
    mkdir -p $out/share/manuskript
    cp -av  bin/ i18n/ libs/ manuskript/ resources/ icons/ $out
    cp -r sample-projects/ $out/share/manuskript
  '';

  postFixup = ''
    wrapQtApp $out/bin/manuskript
  '';

  doCheck = false;

  meta = {
    description = "Open-source tool for writers";
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
    maintainers = with lib.maintainers; [ strawbee ];
    platforms = lib.platforms.unix;
    mainProgram = "manuskript";
  };
}
