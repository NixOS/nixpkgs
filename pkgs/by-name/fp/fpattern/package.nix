{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.9";
  pname = "fpattern";

  src = fetchFromGitHub {
    owner = "Loadmaster";
    repo = "fpattern";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/QvMQCmoocaXfDm3/c3IAPyfZqR6d7IiJ9UoFKZTpVI=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/include
    cp *.c *.h $out/include
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Loadmaster/fpattern";
    description = "Filename pattern matching library functions for DOS, Windows, and Unix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = with lib.platforms; linux;
  };
})
