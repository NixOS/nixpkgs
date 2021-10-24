{ lib, zlib, fetchFromGitHub, python3Packages, wrapQtAppsHook, makeDesktopItem }:

python3Packages.buildPythonApplication rec {
  pname = "manuskript";
  version = "0.12.0";

  format = "other";

  src = fetchFromGitHub {
    repo = pname;
    owner = "olivierkes";
    rev = version;
    sha256 = "0gfwwnpjslb0g8y3v9ha4sd8in6bpy6bhi4rn4hmfd2vmq2flpbd";
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

  installPhase = (
    let
      desktopItem = makeDesktopItem {
        name = "Manuskript";
        exec = "manuskript";
        desktopName = "Manuskript";
        genericName = "Manuskript";
        categories = "Office;";
      };
    in
      ''
        mkdir -p $out/share/${pname}
        cp -av  bin/ i18n/ libs/ manuskript/ resources/ icons/ $out
        cp -a ${desktopItem}/share/applications $out/share
        cp -r sample-projects/ $out/share/${pname}
      '');

  postFixup = ''
    wrapQtApp $out/bin/manuskript
  '';

  doCheck = false;

  meta = {
    description = "A open-source tool for writers";
    homepage = "http://www.theologeek.ch/manuskript";
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
    maintainers = [ lib.maintainers.steveej ];
    platforms = lib.platforms.unix;
  };
}
