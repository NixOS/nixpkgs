{ stdenv
, fetchFromGitHub
, lib
, libGL
, lua
, qmake
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation {
  pname = "trse";
  version = "0.13.337";

  src = fetchFromGitHub {
    owner = "leuat";
    repo = "TRSE";
    rev = "a06ab438db51e31eedf1c9329316672783e7b9e8";
    sha256 = "1hmihjrcvlwvr39737rbvl6nyib1mxzxbbjxfqxpmhw6n14qgi4p";
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    libGL
    lua
    qtbase
  ];

  qmakeFlags = [
    "TRSE.pro"
  ];

  postInstall = ''
    cp -r Publish/project_templates $out
    cp -r Publish/source/themes $out
    cp -r Publish/tutorials $out
    cp -r units $out
  '';

  meta = with lib; {
    description = "Turbo Rascal Syntax Error";
    longDescription = ''
      TRSE (or its full original name "Turbo Rascal Syntax error, ";" expected
      but "BEGIN") is a complete suite (IDE, compiler, programming language and
      resource editor) intended for developing games/demos for 8/16-bit lines
      of computers.
    '';
    homepage = "https://lemonspawn.com/turbo-rascal-syntax-error-expected-but-begin/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ evenbrenden ];
    platforms = [ "x86_64-linux" ];
  };
}
