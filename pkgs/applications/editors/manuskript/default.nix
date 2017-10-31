{ stdenv, zlib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "manuskript";
  version = "0.3.0";

  src = fetchFromGitHub {
    repo = name;
    owner = "olivierkes";
    rev = version;
    sha256 = "0bqxc4a8kyi6xz1zs0dp85wxl9h4v8lzc6073bbcsn1zg4y59ys7";
  };

  propagatedBuildInputs = [
    python3Packages.pyqt5
    python3Packages.lxml
    zlib
  ];

  patchPhase = ''
    substituteInPlace manuskript/ui/welcome.py \
      --replace sample-projects $out/share/${name}/sample-projects
   '';

  buildPhase = '''';

  installPhase = ''
    mkdir -p $out/share/${name}
    cp -av  bin/ i18n/ libs/ manuskript/ resources/ icons/ $out
    cp -r sample-projects/ $out/share/${name}
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
