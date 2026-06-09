{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ncurses,
  pulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrq";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "dj1yfk";
    repo = "qrq";
    rev = "qrq-${finalAttrs.version}";
    hash = "sha256-uuETGbv5qm0Z+45+kK66SBHhQ0Puu6I5z+TWIh3iR2g=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  patches = [
    # gcc15, remove after next release
    (fetchpatch {
      url = "https://github.com/dj1yfk/qrq/commit/f17363df923cd9d4607478a7406e0c4d3e044aae.patch";
      hash = "sha256-EzGP6ExqiK30Vb4f8Q06zIP5Bebnw/jWvaAOb3juZMU=";
      stripLen = 2;
      extraPrefix = "";
    })
  ];

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
    substituteInPlace Makefile \
      --replace-fail 'CC=gcc' 'CC=${stdenv.cc.targetPrefix}cc'
  '';

  meta = {
    description = "High Speed Morse trainer - mirror of https://git.fkurz.net/dj1yfk/qrq";
    homepage = "https://github.com/dj1yfk/qrq";
    changelog = "https://github.com/dj1yfk/qrq/blob/${finalAttrs.src.rev}/ChangeLog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pkharvey ];
    mainProgram = "qrq";
    platforms = lib.platforms.all;
  };
})
