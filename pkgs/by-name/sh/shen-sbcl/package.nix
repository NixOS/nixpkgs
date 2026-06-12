{
  lib,
  stdenvNoCC,
  fetchzip,
  sbcl,
  installStandardLibrary ? true,
  installConcurrency ? true,
  installThorn ? true,
  installLogicLab ? true,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shen-sbcl";
  version = "41.1";

  src = fetchzip {
    url = "https://www.shenlanguage.org/Download/S${finalAttrs.version}.zip";
    hash = "sha256-v/hlP23yfpkpFEDCTKYoxeMJbfR2qVF9LFUkqsFwo6g=";
  };

  sourceRoot = "${finalAttrs.src.name}/S41";
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

    # remove interactive prompts during image creation
    # shen/tk requires further configuration and isn't supported by default
    substituteInPlace Lib/install.shen \
      --replace-fail '(y-or-n? "install standard library?")' '${
        if installStandardLibrary then "true" else "false"
      }' \
      --replace-fail '(y-or-n? "install concurrency? (required for Shen/tk)")' '${
        if installConcurrency then "true" else "false"
      }' \
      --replace-fail '(y-or-n? "install Shen/tk + IDE?")' 'false' \
      --replace-fail '(y-or-n? "install THORN?")' '${if installThorn then "true" else "false"}' \
      --replace-fail '(y-or-n? "install Logic Lab?")' '${if installLogicLab then "true" else "false"}'
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
