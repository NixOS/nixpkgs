{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "notepad-next";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "dail8859";
    repo = "NotepadNext";
    rev = "v${finalAttrs.version}";
    hash = "sha256-I2bS8oT/TGf6fuXpTwOKo2MaUo0jLFIU/DfW9h1toOk=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    description = "A cross-platform, reimplementation of Notepad";
    homepage = "https://github.com/dail8859/NotepadNext";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "NotepadNext";
    platforms = platforms.all;
  };
})
