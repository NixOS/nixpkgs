{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.13";
  pname = "beanstalkd";

  src = fetchFromGitHub {
    owner = "beanstalkd";
    repo = "beanstalkd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xoudhPad4diGGE8iZaY1/4LiENlKT2dYcIR6wlQdlTU=";
  };

  patches = [
    # Fix build with GCC 15, remove after next update
    (fetchpatch {
      url = "https://github.com/beanstalkd/beanstalkd/commit/85070765.patch";
      hash = "sha256-QDDypvrQtjlG7iPE0GfvpZMActIw1gRx36+BpZ6WjMw=";
    })
  ];

  hardeningDisable = [ "fortify" ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage doc/beanstalkd.1
  '';

  passthru.tests = {
    smoke-test = nixosTests.beanstalkd;
  };

  meta = {
    homepage = "http://kr.github.io/beanstalkd/";
    description = "Simple, fast work queue";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimbatm ];
    platforms = lib.platforms.all;
    mainProgram = "beanstalkd";
  };
})
