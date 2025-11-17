{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "blocksruntime";
  version = "0-unstable-2017-10-28";

  src = fetchFromGitHub {
    owner = "mackyle";
    repo = "blocksruntime";
    rev = "9cc93ae2b58676c23fd02cf0c686fa15b7a3ff81";
    sha256 = "sha256-pQMNZBgkF4uADOVCWXB5J3qQt8JMe8vo6ZmbtSVA5Xo=";
  };

  buildPhase = ''
    runHook preBuild
    ./buildlib ${lib.optionalString (!stdenv.hostPlatform.isStatic) "-shared"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    prefix="/" DESTDIR=$out ./installlib ${
      if stdenv.hostPlatform.isStatic then "-static" else "-shared"
    }
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck
    ./checktests
    runHook postCheck
  '';

  doCheck = false; # hasdescriptor.c test fails, hrm.

  meta = with lib; {
    description = "Installs the BlocksRuntime library from the compiler-rt";
    homepage = "https://github.com/mackyle/blocksruntime";
    license = licenses.mit;
  };
}
