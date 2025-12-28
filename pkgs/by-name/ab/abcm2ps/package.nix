{
  lib,
  stdenv,
  fetchfossil,
  fetchpatch2,
  docutils,
  pkg-config,
  freetype,
  pango,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcm2ps";
  version = "8.14.17";

  src = fetchfossil {
    url = "https://chiselapp.com/user/moinejf/repository/abcm2ps";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YA36wfj7owKu/KyWgCj6U8EJEh831cFtQj4/JtH6kVg=";
  };

  patches = [
    # fix build with C23
    #   'bool' is a keyword with '-std=c23' onwards
    #   error: 'bool' cannot be used here
    (fetchpatch2 {
      url = "https://salsa.debian.org/debian/abcm2ps/-/raw/f741931567bb8cac8c9ed8e73b7ba838e4c17eb3/debian/patches/c23.diff";
      hash = "sha256-+2LuHqY5+nWykCYGEOazDeJAf9sggPNp2yiqMQRepfM=";
    })
  ];

  configureFlags = [
    "--INSTALL=install"
  ];

  nativeBuildInputs = [
    docutils
    pkg-config
  ];

  buildInputs = [
    freetype
    pango
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "abcm2ps -V";
    };
  };

  meta = {
    homepage = "http://moinejf.free.fr/";
    license = lib.licenses.lgpl3Plus;
    description = "Command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "abcm2ps";
  };
})
