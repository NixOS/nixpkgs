{ stdenv, zlib, fetchFromGitHub, python3Packages, wrapQtAppsHook }:

python3Packages.buildPythonApplication rec {
  pname = "manuskript";
  version = "0.11.0";

  format = "other";

  src = fetchFromGitHub {
    repo = pname;
    owner = "olivierkes";
    rev = version;
    sha256 = "1l6l9k6k69yv8xqpll0zv9cwdqqg4zvxy90l6sx5nv2yywh5crla";
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

  buildPhase = '''';

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
    homepage = http://www.theologeek.ch/manuskript;
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
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.steveej ];
    platforms = stdenv.lib.platforms.linux;
  };
}
