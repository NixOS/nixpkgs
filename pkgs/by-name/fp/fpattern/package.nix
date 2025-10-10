{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.9";
  pname = "fpattern";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "Loadmaster";
    repo = "fpattern";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/QvMQCmoocaXfDm3/c3IAPyfZqR6d7IiJ9UoFKZTpVI=";
  };

  buildPhase = ''
    runHook preBuild
    $CC $CFLAGS -c *.c
    $AR rcs libfpattern.a *.o
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp libfpattern.a $out/lib/

    mkdir -p $dev/include
    cp *.h $dev/include/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Loadmaster/fpattern";
    description = "Filename pattern matching library functions for DOS, Windows, and Unix";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hughobrien ];
    platforms = lib.platforms.unix;
  };
})
