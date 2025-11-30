{
  lib,
  stdenvNoCC,
  fetchzip,
  sbcl,
  installStandardLibrary ? true,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shen-sbcl";
  version = "39.2";

  src = fetchzip {
    url = "https://www.shenlanguage.org/Download/S${finalAttrs.version}.zip";
    hash = "sha256-V6op0G4aEdKifP6L0ho6cy1FPNax+0aE5ltWxT7Xniw=";
  };

  nativeBuildInputs = [ sbcl ];
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

  postPatch = ''
    # allow SBCL to define *release* global
    substituteInPlace Primitives/globals.lsp \
      --replace-fail '"2.0.0"' '(LISP-IMPLEMENTATION-VERSION)'

    # remove interactive prompt during image creation
    substituteInPlace install.lsp \
      --replace-fail '(Y-OR-N-P "Load Shen Library? ")' '${
        if installStandardLibrary then "T" else "NIL"
      }'
  '';

  meta = {
    homepage = "https://shenlanguage.org";
    description = "Port of Shen running on Steel Bank Common Lisp";
    changelog = "https://shenlanguage.org/download.html#kernel";
    platforms = sbcl.meta.platforms;
    maintainers = with lib.maintainers; [ hakujin ];
    license = lib.licenses.bsd3;
    mainProgram = "shen-sbcl";
  };
})
