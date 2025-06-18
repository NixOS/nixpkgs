{
  lib,
  stdenv,
  fetchfossil,
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

  meta = with lib; {
    homepage = "http://moinejf.free.fr/";
    license = licenses.lgpl3Plus;
    description = "Command line program which converts ABC to music sheet in PostScript or SVG format";
    platforms = platforms.unix;
    maintainers = [ maintainers.dotlambda ];
    mainProgram = "abcm2ps";
  };
})
