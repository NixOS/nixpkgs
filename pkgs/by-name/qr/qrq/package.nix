{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pulseaudio,
}:

stdenv.mkDerivation rec {
  pname = "qrq";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "dj1yfk";
    repo = "qrq";
    rev = "qrq-${version}";
    hash = "sha256-uuETGbv5qm0Z+45+kK66SBHhQ0Puu6I5z+TWIh3iR2g=";
  };

  sourceRoot = "${src.name}/src";

  buildInputs = [
    ncurses
    pulseaudio
  ];

  makeFlags = [
    "BUILD_INFO=nix"
    "DESTDIR=${placeholder "out"}"
  ];

  postPatch = ''
    substituteInPlace qrq.c \
      --replace-fail '[80]' '[4000]' \
      --replace-fail '80,' '4000,'
  '';

  meta = {
    description = "High Speed Morse trainer - mirror of https://git.fkurz.net/dj1yfk/qrq";
    homepage = "https://github.com/dj1yfk/qrq";
    changelog = "https://github.com/dj1yfk/qrq/blob/${src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pkharvey ];
    mainProgram = "qrq";
    platforms = lib.platforms.all;
  };
}
