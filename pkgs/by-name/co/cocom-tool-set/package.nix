{
  lib,
  stdenv,
  fetchgit,
  bison,
}:
stdenv.mkDerivation {
  pname = "cocom";
  version = "0.996";

  src = fetchgit {
    url = "https://git.code.sf.net/p/cocom/git";
    sha256 = "sha256-utLafkznMC4LrZgF6vKehtIGMwNMwLP9M9Nwu/RyWio=";
    rev = "64ee80224aa13f9944d439f3f90862ca76158705";
  };

  nativeBuildInputs = [ bison ];

  patches = [ ./remove-lto.patch ];

  meta = {
    description = "Tool set oriented towards the creation of compilers";
    homepage = "https://cocom.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = lib.platforms.linux;
  };
}
