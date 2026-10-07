{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "enumer";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "dmarkham";
    repo = "enumer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GzmACFskZopDT+5argMCecQios/wiNJsK0Q/1a2MSb0=";
  };

  vendorHash = "sha256-JixRpxMSi7pEFrR4NyrRIP84qFr9IAHdGmQblAjUUWs=";

  meta = {
    description = "Go tool to auto generate methods for enums";
    homepage = "https://github.com/dmarkham/enumer";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "enumer";
  };
})
