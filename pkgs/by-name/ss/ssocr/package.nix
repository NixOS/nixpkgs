{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  libx11,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssocr";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BRsDnJ0nXgx6GR74uRQONySp0Xdhnn7f+6E5nUwxDLQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    imlib2
    libx11
  ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Seven Segment Optical Character Recognition";
    homepage = "https://github.com/auerswal/ssocr";
    license = lib.licenses.gpl3;
    mainProgram = "ssocr";
    platforms = lib.platforms.unix;
  };
})
