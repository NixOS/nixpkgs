{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kanjidraw";
  version = "0.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "kanjidraw";
    rev = "v${version}";
    sha256 = "03ag8vkbf85qww857ii8hcnn8bh5qa7rsmhka0v9vfxk272ifbyq";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [ tkinter ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail /bin/bash bash
  '';

  checkPhase = ''
    make test
  '';

  pythonImportsCheck = [ "kanjidraw" ];

  meta = with lib; {
    description = "Handwritten kanji recognition";
    mainProgram = "kanjidraw";
    longDescription = ''
      kanjidraw is a simple Python library + GUI for matching (the strokes of a)
      handwritten kanji against its database.

      You can use the GUI to draw and subsequently select a kanji from the list of
      probable matches, which will then be copied to the clipboard.

      The database is based on KanjiVG and the algorithms are based on the
      Kanji draw Android app.
    '';
    homepage = "https://github.com/obfusk/kanjidraw";
    license = with licenses; [
      agpl3Plus # code
      cc-by-sa-30 # data.json
    ];
    maintainers = [ maintainers.obfusk ];
  };
}
