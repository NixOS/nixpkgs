{
  lib,
  stdenvNoCC,
  fetchzip,
  sbcl,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shen-sbcl";
  version = "39.1";
  nativeBuildInputs = [ sbcl ];
  src = fetchzip {
    url = "https://www.shenlanguage.org/Download/S${finalAttrs.version}.zip";
    hash = "sha256-reN9avgYGYCMiA5BeHLhRK51liKF2ctqIgxf+4IWjVY=";
  };
  dontStrip = true; # necessary to prevent runtime errors with sbcl
  buildPhase = ''
    runHook preBuild

    sbcl --noinform --no-sysinit --no-userinit --load install.lsp

    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall

    install -Dm755 sbcl-shen.exe $out/bin/shen-sbcl

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://shenlanguage.org";
    description = "Port of Shen running on Steel Bank Common Lisp";
    changelog = "https://shenlanguage.org/download.html#kernel";
    platforms = sbcl.meta.platforms;
    maintainers = with maintainers; [ bsima ];
    license = licenses.bsd3;
    mainProgram = "shen-sbcl";
  };
})
