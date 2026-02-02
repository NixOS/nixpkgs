{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  libX11,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssocr";
  version = "2.25.1";

  src = fetchFromGitHub {
    owner = "auerswal";
    repo = "ssocr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GRjUCE4l/IIAqV+W2s/+HaGMKqfSTmEQeW28o4Gkw/A=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    imlib2
    libX11
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
