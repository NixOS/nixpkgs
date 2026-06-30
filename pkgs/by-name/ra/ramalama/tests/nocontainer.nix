{
  callPackage,
  fetchurl,
  lib,
  ramalama,
}:

let
  common = callPackage ./common.nix {
    inherit ramalama;
  };

  model = fetchurl {
    url = "https://huggingface.co/ibm-granite/granite-3.3-2b-instruct-GGUF/resolve/main/granite-3.3-2b-instruct-Q2_K.gguf";
    hash = "sha256-i+Jb5ltKKVV4H9k99R9HUub2/lwDW+pVc7l1OHNt/t0=";
    meta.license = lib.licenses.asl20;
  };

  modelArg = "file://${model}";
in
common.mkServeTest {
  name = "ramalama-nocontainer-test";
  runtime = "llama.cpp";
  port = 18080;
  model = modelArg;
  globalArgs = [ "--nocontainer" ];
  serveArgs = [
    "--ngl"
    "0"
    "--threads"
    "1"
    "--ctx-size"
    "256"
    "--max-tokens"
    "16"
    "--pull"
    "never"
    "--temp"
    "0"
    "--thinking"
    "off"
    "--webui"
    "off"
  ];

  setup = ''
    ramalama \
      --nocontainer \
      --runtime llama.cpp \
      --store "$TMPDIR/store" \
      pull \
      ${lib.escapeShellArg modelArg}
  '';
}
