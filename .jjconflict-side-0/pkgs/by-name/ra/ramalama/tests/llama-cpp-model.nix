{ fetchurl }:

"file://${
  fetchurl {
    url = "https://huggingface.co/bartowski/SmolLM2-135M-Instruct-GGUF/resolve/main/SmolLM2-135M-Instruct-Q4_K_M.gguf";
    hash = "sha256-LoBAzq54Favg3LNUC5mV6qH6DSyp55fQpjWuRDPGjC0=";
  }
}"
