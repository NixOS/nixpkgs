{
  fetchurl,
  lib,
  libxcrypt,
  ncurses,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kermit";
  version = "9.0.302";

  src = fetchurl {
    url = "ftp://ftp.kermitproject.org/kermit/archives/cku${lib.versions.patch finalAttrs.version}.tar.gz";
    hash = "sha256-DV8s0SvauUAbTINoVOu/JBZ1BRh1VXeDwzKmpA2sBxE=";
  };

  sourceRoot = ".";

  strictDeps = true;

  buildInputs = [
    libxcrypt
    ncurses
  ];

  postPatch = ''
    sed -i -e 's@-I/usr/include/ncurses@@' \
      -e 's@/usr/local@'"$out"@ makefile
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration -Wno-implicit-int";

  buildPhase = ''
    runHook preBuild
    make linux KFLAGS='-D_IO_file_flags -std=gnu89' LNKFLAGS='-lcrypt -lresolv'
    runHook postBuild
  '';

  preInstall = ''
    mkdir --parents $out/{bin,man/man1}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://www.kermitproject.org/ckupdates.html#ck${
      lib.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }";
    description = "Portable Scriptable Network and Serial Communication Software";
    homepage = "https://www.kermitproject.org/ck90.html";
    license = lib.licenses.bsd3;
    mainProgram = "kermit";
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
