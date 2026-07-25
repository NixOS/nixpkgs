{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "risp";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vksarchy";
    repo = "risp";
    rev = "v${version}";
    hash = "sha256-l7wGc6OKt0UvreH84+hRA6FLZguYjidV3hxpRWd1dvo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    rich
    ebooklib
    pypdf
  ];

  doCheck = false;

  pythonImportsCheck = [
    "risp"
    "risp.cli"
  ];

  meta = {
    description = "Terminal RSVP speed reader for text, Markdown, Org, PDF, and EPUB";
    longDescription = ''
      risp (Rapid Interactive Serial Presentation) shows documents as a
      per-word RSVP stream with an optical recognition point (ORP) focus
      letter, adjustable WPM, ETA, and sentence context on pause.
    '';
    homepage = "https://github.com/vksarchy/risp";
    license = lib.licenses.mit;
    mainProgram = "risp";
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}