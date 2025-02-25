{
  lib,
  stdenvNoCC,
  fetchzip,
  sbcl,
}:
let
  kernel-version = "S39.1";
in
stdenvNoCC.mkDerivation {
  pname = "shen-sbcl";
  version = "0-${kernel-version}";
  nativeBuildInputs = [ sbcl ];
  src = fetchzip {
    url = "https://www.shenlanguage.org/Download/${kernel-version}.zip";
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
    maintainers = [ maintainers.hakujin ];
    license = licenses.bsd3;
  };
}
