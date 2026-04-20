{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libfido2,
}:
buildGoModule (finalAttrs: {
  pname = "age-plugin-fido2prf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "typage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JGEn1xIzfLyoCWd/aRRG08Z/OoviEyZF+tGEfcj9DXw=";
  };

  srcRoot = "${finalAttrs.src}/fido2prf/cmd/age-plugin-fido2prf";
  vendorHash = "sha256-XrgZBvNyVUhKJ87vfd9aZh6aW+JifJWUu/ggNQZKwo0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  buildInputs = [ libfido2 ];

  meta = {
    description = "Age plugin to encrypt files with FIDO2 tokens in a way compatible to typage";
    homepage = "https://github.com/FiloSottile/typage/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ claraphyll ];
    mainProgram = "age-plugin-fido2prf";
  };
  __structuredAttrs = true;
})
