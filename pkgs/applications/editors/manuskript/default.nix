{ stdenv, zlib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "manuskript";
  version = "0.8.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "olivierkes";
    rev = version;
    sha256 = "0vqz02p3m9n4hk2jplnklr9s6niqdm5iykab6nblqdm4plb04c34";
  };

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
