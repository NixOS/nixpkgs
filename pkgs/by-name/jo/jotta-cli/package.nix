{
  lib,
  stdenv,
  fetchzip,
  nixosTests,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "jotta-cli";
  version = "0.17.148769";

  src = fetchzip {
    url = "https://repo.jotta.us/archives/linux/amd64/jotta-cli-${version}_linux_amd64.tar.gz";
    hash = "sha256-uI5yYpyLa7gGg9eL1nG5MMwHZ2j2yH5/8n5sB/WgoQI=";
    stripRoot = false;
  };

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 usr/bin/jotta-cli usr/bin/jottad -t $out/bin/

    runHook postInstall
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd jotta-cli \
      --bash <($out/bin/jotta-cli completion bash) \
      --fish <($out/bin/jotta-cli completion fish) \
      --zsh <($out/bin/jotta-cli completion zsh)
  '';

  passthru.tests = { inherit (nixosTests) jotta-cli; };

  meta = {
    description = "Jottacloud CLI";
    homepage = "https://www.jottacloud.com/";
    downloadPage = "https://repo.jotta.us/archives/linux/";
    maintainers = with lib.maintainers; [ evenbrenden ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
