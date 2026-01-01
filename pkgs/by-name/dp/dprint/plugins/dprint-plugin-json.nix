{ mkDprintPlugin }:
mkDprintPlugin {
  description = "JSON/JSONC code formatter";
<<<<<<< HEAD
  hash = "sha256-CetVbLXlgZcrBs6yxFNqkK4DK4TThL7qiDfJkYhFTN8=";
=======
  hash = "sha256-GIoIkW7szyQU4GyLUdj0TTaV8FWg1jzvOerOChHiR7w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  initConfig = {
    configExcludes = [ "**/*-lock.json" ];
    configKey = "json";
    fileExtensions = [ "json" ];
  };
  pname = "dprint-plugin-json";
  updateUrl = "https://plugins.dprint.dev/dprint/json/latest.json";
<<<<<<< HEAD
  url = "https://plugins.dprint.dev/json-0.21.1.wasm";
  version = "0.21.1";
=======
  url = "https://plugins.dprint.dev/json-0.21.0.wasm";
  version = "0.21.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
