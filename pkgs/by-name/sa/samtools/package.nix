{
  lib,
  stdenv,
  fetchurl,
  zlib,
  htslib,
  perl,
  nix-update-script,
  ncurses ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samtools";
  version = "1.24";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/samtools/samtools/releases/download/${finalAttrs.version}/samtools-${finalAttrs.version}.tar.bz2";
    hash = "sha256-ibKkQBI+6qQAOSzhc259YM6QQYQwJ9doGXU8WoJGv90=";
  };

  # tests require `bgzip` from the htslib package
  nativeCheckInputs = [ htslib ];

  nativeBuildInputs = [ perl ];

  buildInputs = [
    zlib
    ncurses
    htslib
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isStatic ''
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tools for manipulating SAM/BAM/CRAM format";
    license = lib.licenses.mit;
    homepage = "https://www.htslib.org/";
    changelog = "https://github.com/samtools/samtools/releases";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mimame
      unode
    ];
  };
})
