{
  lib,
  stdenv,
  fetchurl,
  texliveSmall,
  writableTmpDirAsHomeHook,
  gmp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ratpoints";
  version = "2.2.2";

  src = fetchurl {
    url = "https://www.mathe2.uni-bayreuth.de/stoll/programs/ratpoints-${finalAttrs.version}.tar.gz";
    hash = "sha256-2A4VIhkKHhIvey3i78Je+qyQf1XzdjXY2t3Q0Yqv/ZM=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    (texliveSmall.withPackages (
      ps: with ps; [
        charter
        comment
        cyrillic
        preprint
        titlesec
        xypic
      ]
    ))
    writableTmpDirAsHomeHook
  ];

  buildInputs = [ gmp ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  buildFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "CCFLAGS2=-lgmp -lc -lm"
    "CCFLAGS=-UUSE_SSE"
  ];
  installFlags = [ "INSTALL_DIR=$(out)" ];

  preInstall = ''mkdir -p "$out"/{bin,share,lib,include}'';

  meta = {
    description = "Program to find rational points on hyperelliptic curves";
    mainProgram = "ratpoints";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
    homepage = "http://www.mathe2.uni-bayreuth.de/stoll/programs/";
  };
})
