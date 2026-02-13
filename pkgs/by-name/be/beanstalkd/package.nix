{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.13";
  pname = "beanstalkd";

  src = fetchFromGitHub {
    owner = "kr";
    repo = "beanstalkd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xoudhPad4diGGE8iZaY1/4LiENlKT2dYcIR6wlQdlTU=";
  };

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
