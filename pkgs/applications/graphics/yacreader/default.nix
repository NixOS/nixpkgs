{ mkDerivation, lib, fetchFromGitHub, qmake, poppler, pkg-config, libunarr
, libGLU, qtdeclarative, qtgraphicaleffects, qtmultimedia, qtquickcontrols2
, qtscript
}:

mkDerivation rec {
  pname = "yacreader";
  version = "9.14.2";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = pname;
    rev = version;
    sha256 = "sha256-gQ4Aaapini6j3lCtowFbrfwbe91aFl50hp1EfxTO8uY=";
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ poppler libunarr libGLU qtmultimedia qtscript ];
  propagatedBuildInputs = [ qtquickcontrols2 qtgraphicaleffects qtdeclarative ];

  meta = {
    description = "Comic reader for cross-platform reading and managing your digital comic collection";
    homepage = "http://www.yacreader.com";
    license = lib.licenses.gpl3;
    mainProgram = "YACReader";
    maintainers = [ ];
  };
}
