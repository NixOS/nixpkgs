{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "cw";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "lucagrulla";
    repo = "cw";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JsWwvVEr7kSjUy0S6wVcn24Xyo4OHr5/uqmnjw6v+RI=";
  };

  vendorHash = "sha256-8L4q0IAvmNk5GCAC5agNfWFtokIkddO1Dec4m6/sWfg=";

  meta = {
    description = "Best way to tail AWS CloudWatch Logs from your terminal";
    homepage = "https://github.com/lucagrulla/cw";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ onthestairs ];
    mainProgram = "cw";
  };
})
