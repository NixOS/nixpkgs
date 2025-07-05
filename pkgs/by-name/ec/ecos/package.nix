{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ecos";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "embotech";
    repo = "ecos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WMgqDc+XAY3g2wwlefjJ0ATxR5r/jL971FZKtxsunnU=";
  };

  buildPhase = ''
    runHook preBuild

    make all shared

    runHook postBuild
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make test
    ./runecos

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp lib*.a lib*.so $out/lib
    cp -r include $out/

    runHook postInstall
  '';

  meta = {
    description = "Lightweight conic solver for second-order cone programming";
    homepage = "https://www.embotech.com/ECOS";
    downloadPage = "https://github.com/embotech/ecos/releases";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bhipple ];
  };
})
