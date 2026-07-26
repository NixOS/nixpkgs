{
  fetchFromGitHub,
  stdenv,
  lib,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "outguess";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "resurrecting-open-source-projects";
    repo = "outguess";
    tag = finalAttrs.version;
    hash = "sha256-yv01jquPTnVk9fd1tqAt1Lxis+ZHZqdG3NiTFxfoXAE=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  strictDeps = true;

  configureFlags = [ "--with-generic-jconfig" ];

  # Fix build with modern compilers (GCC 14+)
  # The bundled jpeg-6b-steg library uses K&R-style function declarations
  # that are incompatible with modern C standards
  postPatch = ''
    substituteInPlace src/jpeg-6b-steg/jmorecfg.h \
      --replace-fail '#define JMETHOD(type,methodname,arglist)  type (*methodname) ()' \
                     '#define JMETHOD(type,methodname,arglist)  type (*methodname) arglist'
    substituteInPlace src/jpeg-6b-steg/jpeglib.h \
      --replace-fail '#ifdef HAVE_PROTOTYPES' '#if 1  /* Force ANSI prototypes */'
  '';

  meta = {
    description = "Universal steganographic tool that allows the insertion of hidden information into the redundant bits of data sources";
    homepage = "https://github.com/resurrecting-open-source-projects/outguess";
    license = lib.licenses.bsdOriginal;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    mainProgram = "outguess";
    platforms = lib.platforms.unix;
  };
})
