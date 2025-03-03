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
  version = "1.2.3";

  src = fetchfossil {
    url = "https://objfw.nil.im/home";
    rev = "${finalAttrs.version}-release";
    hash = "sha256-qYZkuJ57/bhvKukXECHC38ooDQ8GE2vbuvY/bvH4ZVY=";
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
