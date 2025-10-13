{
  lib,
  stdenv,
  testers,
  fetchFromGitHub,
  zlib,
  cups,
  libpng,
  libjpeg,
  pkg-config,
  htmldoc,
}:

stdenv.mkDerivation rec {
  pname = "htmldoc";
  version = "1.9.21";
  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "htmldoc";
    rev = "v${version}";
    hash = "sha256-MZKXEwJdQzn49JIUm4clqKBTtjKu6tBU5Sdq6ESn1k4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    zlib
    cups
    libpng
    libjpeg
  ];

  # do not generate universal binary on Darwin
  # because it is not supported by Nix's clang
  postPatch = ''
    substituteInPlace configure --replace-fail "-arch x86_64 -arch arm64" ""
  '';

  passthru.tests = testers.testVersion {
    package = htmldoc;
    command = "htmldoc --version";
  };

  meta = {
    description = "Converts HTML files to PostScript and PDF";
    homepage = "https://michaelrsweet.github.io/htmldoc";
    changelog = "https://github.com/michaelrsweet/htmldoc/releases/tag/v${version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;

    longDescription = ''
      HTMLDOC is a program that reads HTML source files or web pages and
      generates corresponding HTML, PostScript, or PDF files with an optional
      table of contents.
    '';
    mainProgram = "htmldoc";
  };
}
