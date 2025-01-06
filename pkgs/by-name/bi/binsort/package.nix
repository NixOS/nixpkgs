{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "binsort";
  version = "0.4-1";

  src = fetchurl {
    url = "http://neoscientists.org/~tmueller/binsort/download/binsort-${finalAttrs.version}.tar.gz";
    hash = "sha256-l9T0LlDslxCgZYf8NrbsRly7bREOTGwptLteeg3TNRg=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp binsort $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sort files by binary similarity";
    mainProgram = "binsort";
    homepage = "http://neoscientists.org/~tmueller/binsort/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ numinit ];
    platforms = platforms.unix;
  };
})
