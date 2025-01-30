{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  txt2tags,
}:

stdenv.mkDerivation rec {
  pname = "libixp";
  version = "unstable-2022-04-04";

  src = fetchFromGitHub {
    owner = "0intro";
    repo = "libixp";
    rev = "ca2acb2988e4f040022f0e2094c69ab65fa6ec53";
    hash = "sha256-S25DmXJ7fN0gXLV0IzUdz8hXPTYEHmaSG7Mnli6GQVc=";
  };

  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace mk/ixp.mk \
      --replace "©" "C "
  '';

  postConfigure = ''
    sed -i -e "s|^PREFIX.*=.*$|PREFIX = $out|" config.mk
  '';

  nativeBuildInputs = [ unzip ];
  buildInputs = [ txt2tags ];

  meta = {
    homepage = "https://github.com/0intro/libixp";
    description = "Portable, simple C-language 9P client and server library";
    mainProgram = "ixpc";
    maintainers = with lib.maintainers; [ kovirobi ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; unix;
  };
}
