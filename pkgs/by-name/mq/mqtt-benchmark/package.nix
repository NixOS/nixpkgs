{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mqtt-benchmark";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "krylovsk";
    repo = "mqtt-benchmark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gejLDtJ1geO4eDBapHjXgpc+M2TRGKcv5YzybmIyQSs=";
  };

  vendorHash = "sha256-ZN5tNDIisbhMMOA2bVJnE96GPdZ54HXTneFQewwJmHI=";

  meta = {
    description = "MQTT broker benchmarking tool";
    homepage = "https://github.com/krylovsk/mqtt-benchmark";
    changelog = "https://github.com/krylovsk/mqtt-benchmark/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mqtt-benchmark";
  };
})
