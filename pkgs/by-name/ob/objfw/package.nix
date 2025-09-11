{
  autoconf,
  autogen,
  automake,
  clangStdenv,
  fetchFromGitea,
  lib,
  objfw,
  openssl,
  writeTextDir,
  openSslSupport ? false,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "objfw";
  version = "1.4.1";

  src = fetchFromGitea {
    domain = "git.nil.im";
    owner = "ObjFW";
    repo = "ObjFW";
    tag = "${finalAttrs.version}-release";
    hash = "sha256-XR0i8XEbWPIWRnfxtqOIrpAlM8DDiu/mvP63hvdDAK4=";
  };

  nativeBuildInputs = [
    automake
    autogen
    autoconf
  ]
  ++ lib.optional openSslSupport openssl;

  preConfigure = "./autogen.sh";
  configureFlags = [
    "--without-tls"
  ];

  doCheck = true;

  passthru.tests = {
    build-hello-world = (import ./test-build-and-run.nix) { inherit clangStdenv objfw writeTextDir; };
    build-hello-world-ssl = (import ./test-build-and-run-ssl.nix) {
      inherit clangStdenv objfw writeTextDir;
    };
  };

  meta = {
    description = "Portable framework for the Objective-C language";
    homepage = "https://objfw.nil.im";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.linux;
  };
})
