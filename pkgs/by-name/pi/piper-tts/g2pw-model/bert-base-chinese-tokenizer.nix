{
  stdenv,
  fetchurl,
  lib,
}:
stdenv.mkDerivation {
  pname = "bert-base-chinese-tokenizer";
  version = "0.0.0";

  srcs =
    let
      rev = "8f23c25b06e129b6c986331a13d8d025a92cf0ea";
    in
    [
      (fetchurl {
        url = "https://huggingface.co/google-bert/bert-base-chinese/resolve/${rev}/config.json";
        hash = "sha256-iK92LPsV+pzhg8hNy/3J1jUZa6Y13+gfJl/dIdZ/TEw=";
      })
      (fetchurl {
        url = "https://huggingface.co/google-bert/bert-base-chinese/resolve/${rev}/vocab.txt";
        hash = "sha256-RbusazQcMZrcmKUyUyiC6Rqc78AymqV7rJrnYcJ7KRw=";
      })
      (fetchurl {
        url = "https://huggingface.co/google-bert/bert-base-chinese/resolve/${rev}/tokenizer_config.json";
        hash = "sha256-D20T5vTab54k8iraa8O+VxEj2FjXwMBainzVWpwjwug=";
      })
    ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    for s in $srcs; do
      cp "$s" "$out/$(stripHash "$s")"
    done

    runHook postInstall
  '';

  meta = {
    description = "This model has been pre-trained for Chinese, training and random input masking has been applied independently to word pieces (as in the original BERT paper).";
    homepage = "https://huggingface.co/google-bert/bert-base-chinese";
    license = lib.licenses.asl20;
  };
}
