{ lib
, stdenv
, qrcodegen
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrcodegencpp";
  version = qrcodegen.version;

  src = qrcodegen.src;

  sourceRoot = "${finalAttrs.src.name}/cpp";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [
    stdenv.cc.cc.libllvm.out
  ];

  makeFlags = lib.optionals stdenv.cc.isClang [ "AR=llvm-ar" ];

  installPhase = ''
    runHook preInstall

    install -Dt $out/lib/ libqrcodegencpp.a
    install -Dt $out/include/qrcodegen/ qrcodegen.hpp

    runHook postInstall
  '';

  meta = {
    inherit (qrcodegen.meta) description homepage license maintainers platforms;
  };
})
