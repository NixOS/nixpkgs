{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,

  pkg-config,
  libopus,
  whisper-cpp,

  nixosTests,
  galene,
}:

buildGoModule (finalAttrs: {
  pname = "galene-stt";
  version = "0.4";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jech";
    repo = "galene-stt";
    tag = "galene-stt-${finalAttrs.version}";
    hash = "sha256-JJp29QW3Tb6/sZRSFjXcCaQ0MbPhjGUjuYg0+qK/YKo=";
  };

  vendorHash = "sha256-AY1nAN1bxk+sjub/NOjpARmR95jq1AvRPIsmm+vJlhI=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libopus
    whisper-cpp
  ];

  ldflags = [ "-s" ];

  passthru = {
    # This model is licensed mit: https://github.com/openai/whisper#license
    testModel = fetchurl {
      url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/ggml-tiny.en.bin";
      hash = "sha256-kh5M+Ghv3Zk9zQgaXaW2w2W/3hFi5ysI11rHUomSCx8=";
    };
    tests = nixosTests.galene;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Speech-to-text support for Galene";
    homepage = "https://github.com/jech/galene-stt";
    changelog = "https://github.com/jech/galene-stt/blob/${finalAttrs.src.rev}/CHANGES";
    license = lib.licenses.mit;
    inherit (galene.meta) maintainers teams;
    mainProgram = "galene-stt";
  };
})
