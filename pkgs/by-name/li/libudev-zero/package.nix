{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libudev-zero";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "illiliti";
    repo = "libudev-zero";
    rev = finalAttrs.version;
    sha256 = "sha256-NXDof1tfr66ywYhCBDlPa+8DUfFj6YH0dvSaxHFqsXI=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  # Just let the installPhase build stuff, because there's no
  # non-install target that builds everything anyway.
  dontBuild = true;

  installTargets = lib.optionals stdenv.hostPlatform.isStatic "install-static";

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    homepage = "https://github.com/illiliti/libudev-zero";
    description = "Daemonless replacement for libudev";
    changelog = "https://github.com/illiliti/libudev-zero/releases/tag/${version}";
    maintainers = with maintainers; [
      qyliss
      shamilton
    ];
    license = licenses.isc;
    pkgConfigModules = [ "libudev" ];
    platforms = platforms.linux;
  };
})
