{
  lib,
  stdenv,
  fetchurl,
  zlib,
  htslib,
  perl,
  ncurses ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samtools";
  version = "1.22.1";

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${finalAttrs.version}/samtools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Aqpc0LpS4GwggAVOBZ19d6iF3+lxfDHNid/npAR+2g4=";
  };

  # tests require `bgzip` from the htslib package
  nativeCheckInputs = [ htslib ];

  nativeBuildInputs = [ perl ];

  buildInputs = [
    zlib
    ncurses
    htslib
  ];

  preConfigure = lib.optional stdenv.hostPlatform.isStatic ''
    export LIBS="-lz -lbz2 -llzma"
  '';
  makeFlags = lib.optional stdenv.hostPlatform.isStatic "AR=${stdenv.cc.targetPrefix}ar";

  configureFlags = [
    "--with-htslib=${htslib}"
  ]
  ++ lib.optional (ncurses == null) "--without-curses"
  ++ lib.optionals stdenv.hostPlatform.isStatic [ "--without-curses" ];

  preCheck = ''
    patchShebangs test/
  '';

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = lib.licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mimame
      unode
    ];
  };
})
