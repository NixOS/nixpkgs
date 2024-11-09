{
  autoconf,
  autogen,
  automake,
  clangStdenv,
  fetchFromGitHub,
  lib,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "objfw";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "ObjFW";
    repo = "ObjFW";
    rev = "refs/tags/1.2-release";
    hash = "sha256-nGajiLYwkIDyJujN2zWULkQXKV2A2wzjYl9IoZBU/N4=";
  };

  nativeBuildInputs = [
    automake
    autogen
    autoconf
  ];

  preConfigure = "./autogen.sh";
  configureFlags = [
    "--without-tls"
  ];

  doCheck = true;

  meta = {
    description = "A portable framework for the Objective-C language";
    homepage = "https://github.com/ObjFW/ObjFW";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.linux;
  };
})
