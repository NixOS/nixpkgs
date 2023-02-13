{ lib, stdenv, fetchzip }:

let
  arch = "amd64";
in
stdenv.mkDerivation rec {
  pname = "jotta-cli";
  version = "0.14.60923";
  src = fetchzip {
      url = "https://repo.jotta.us/archives/linux/${arch}/jotta-cli-${version}_linux_${arch}.tar.gz";
      sha256 = "sha256-9R2eml0MpOZQn8SIs8gN1d1ddQdKmTsPBEWqHCvW8yo=";
      stripRoot = false;
    };

  installPhase = ''
    install -D usr/bin/jotta-cli usr/bin/jottad -t $out/bin/
    mkdir -p $out/share/bash-completion/completions
  '';

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/jotta-cli
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/jottad
    $out/bin/jotta-cli completion bash > $out/share/bash-completion/completions/jotta-cli.bash
  '';

  meta = with lib; {
    description  = "Jottacloud CLI";
    homepage     = "https://www.jottacloud.com/";
    downloadPage = "https://repo.jotta.us/archives/linux/";
    maintainers  = with maintainers; [ evenbrenden ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license      = licenses.unfree;
    platforms    = [ "x86_64-linux" ];
  };
}
