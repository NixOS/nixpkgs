{ mkDerivation, lib, fetchFromGitHub, qmake, poppler, pkg-config, libunarr
, libGLU, qtdeclarative, qtgraphicaleffects, qtmultimedia, qtquickcontrols2
, qtscript
}:

mkDerivation rec {
  pname = "yacreader";
<<<<<<< HEAD
  version = "9.13.1";
=======
  version = "9.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-kiacyHA/G0TnRH/96RqDTF7vdDnf2POMw/iSgtSRbmM=";
=======
    sha256 = "sha256-sIQxUiTGQCcHmxBp0Mf49e/XVaJe7onlLHiorMlNLZ8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [ poppler libunarr libGLU qtmultimedia qtscript ];
  propagatedBuildInputs = [ qtquickcontrols2 qtgraphicaleffects qtdeclarative ];

  meta = {
    description = "A comic reader for cross-platform reading and managing your digital comic collection";
    homepage = "http://www.yacreader.com";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ srapenne ];
  };
}
