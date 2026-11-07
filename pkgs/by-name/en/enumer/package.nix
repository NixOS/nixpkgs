{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  go,
}:

buildGoModule (finalAttrs: {
  pname = "enumer";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TQr0ifGt4cB1RN0xNNIjlycB27CFU8x2cCvmkCrNaJ0=";
  };

  vendorHash = "sha256-JixRpxMSi7pEFrR4NyrRIP84qFr9IAHdGmQblAjUUWs=";

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
  ];

  allowGoReference = true;

  postFixup = ''
    wrapProgram "$out/bin/enumer" \
      --prefix PATH : ${go}/bin
  '';

  meta = {
    description = "Go tool to auto generate methods for enums";
    homepage = "https://github.com/dmarkham/enumer";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "enumer";
  };
})
