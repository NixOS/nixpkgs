{
  autoconf,
  autogen,
  automake,
  clangStdenv,
  fetchFromGitea,
  gitUpdater,
  lib,
  objfw,
  writeTextDir,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "objfw";
  version = "1.5.1";

  src = fetchFromGitea {
    domain = "git.nil.im";
    owner = "ObjFW";
    repo = "ObjFW";
    rev = "${finalAttrs.version}-release";
    hash = "sha256-5ECvNsDU3MagbS2tVq2sJCRMQHBkCuMQHqpWlB6tbR8=";
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

  passthru.updateScript = gitUpdater { rev-suffix = "-release"; };

  meta = {
    description = "Portable framework for the Objective-C language";
    homepage = "https://objfw.nil.im";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.steeleduncan ];
    platforms = lib.platforms.linux;
  };
})
