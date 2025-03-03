{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrcodegen";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "nayuki";
    repo = "QR-Code-generator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aci5SFBRNRrSub4XVJ2luHNZ2pAUegjgQ6pD9kpkaTY=";
  };

  sourceRoot = "${finalAttrs.src.name}/c";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [
    stdenv.cc.cc.libllvm.out
  ];

  makeFlags = lib.optionals stdenv.cc.isClang [ "AR=llvm-ar" ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    ./qrcodegen-test

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dt $out/lib/ libqrcodegen.a
    install -Dt $out/include/qrcodegen/ qrcodegen.h

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.nayuki.io/page/qr-code-generator-library";
    description = "High-quality QR Code generator library in many languages";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
# TODO: build the other languages
# TODO: multiple outputs
