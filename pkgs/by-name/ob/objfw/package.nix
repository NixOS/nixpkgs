{
  autoconf,
  autogen,
  automake,
  clangStdenv,
  fetchfossil,
  lib,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "objfw";
  version = "1.2";

  src = fetchfossil {
    url = "https://objfw.nil.im/home";
    rev = "${finalAttrs.version}-release";
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
    homepage = "https://objfw.nil.im";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.linux;
  };
})
