{
  autoconf,
  autogen,
  automake,
  clangStdenv,
  fetchfossil,
  lib,
  objfw,
  writeTextDir,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "objfw";
  version = "1.3.2";

  src = fetchfossil {
    url = "https://objfw.nil.im/home";
    rev = "${finalAttrs.version}-release";
    hash = "sha256-cFYsiNG60FyDXAeiuBZn/u/1dEawVAxF7EDFBZRYt7w=";
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

  passthru.tests = {
    build-hello-world = (import ./test-build-and-run.nix) { inherit clangStdenv objfw writeTextDir; };
  };

  meta = {
    description = "Portable framework for the Objective-C language";
    homepage = "https://objfw.nil.im";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.linux;
  };
})
