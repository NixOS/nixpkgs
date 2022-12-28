{ mkDerivation, lib, fetchFromGitHub, qmake, poppler, pkg-config, libunarr
, libGLU, qtdeclarative, qtgraphicaleffects, qtmultimedia, qtquickcontrols2
, qtscript
}:

mkDerivation rec {
  pname = "yacreader";
  version = "9.10.0";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = pname;
    rev = version;
    sha256 = "sha256-77+lsEvmwQ34maW+HA/IpPsEezlzYEYipc74yR6inwU=";
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
