{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "20kly";
  version = "1.5.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "20kly";
    repo = "20kly";
    tag = "v${version}";
    hash = "sha256-Hd674RtYHwDZLjTz5IIFewOlqphvjt7iP1MAlcjruv8=";
  };

  patchPhase = ''
    substituteInPlace lightyears \
      --replace \
        "LIGHTYEARS_DIR = \".\"" \
        "LIGHTYEARS_DIR = \"$out/share\""
  '';

  propagatedBuildInputs = with python3Packages; [
    pygame
  ];

  buildPhase = ''
    python -O -m compileall .
  '';

  installPhase = ''
    mkdir -p "$out/share"
    cp -r data lib20k lightyears "$out/share"
    install -Dm755 lightyears "$out/bin/lightyears"
  '';

  meta = {
    description = "Steampunk-themed strategy game where you have to manage a steam supply network";
    mainProgram = "lightyears";
    homepage = "http://jwhitham.org.uk/20kly/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
