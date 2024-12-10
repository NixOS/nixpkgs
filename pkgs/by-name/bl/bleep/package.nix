{
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  installShellFiles,
  makeWrapper,
  lib,
  zlib,
  testers,
}:
let
  platform =
    {
      x86_64-linux = "x86_64-pc-linux";
      x86_64-darwin = "x86_64-apple-darwin";
      aarch64-darwin = "arm64-apple-darwin";
    }
    ."${stdenvNoCC.system}" or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}");

  hash =
    {
      x86_64-linux = "sha256-Y9vWtuv1eyrPmJn/XpAw4uDHxhLUdhKszwJZmMIOCqI=";
      x86_64-darwin = "sha256-p8Y6XKHb/CmRcnQ7po3s3oUZh0f+1iIHk38sAu2qym8=";
      aarch64-darwin = "sha256-Qfqeo5syprwtLoNdi/EwsI+EYdpKkkVlFVja8uIFDsM=";
    }
    ."${stdenvNoCC.system}" or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bleep";
  version = "0.0.11";

  src = fetchzip {
    url = "https://github.com/oyvindberg/bleep/releases/download/v${finalAttrs.version}/bleep-${platform}.tar.gz";
    hash = hash;
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ] ++ lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bleep -t $out/bin/
    runHook postInstall
  '';

  dontAutoPatchelf = true;

  postFixup =
    lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      autoPatchelf $out
    ''
    + ''
      export PATH=$PATH:$out/bin
      installShellCompletion --cmd bleep \
        --bash <(bleep install-tab-completions-bash --stdout) \
        --zsh <(bleep install-tab-completions-zsh --stdout) \
    '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "bleep --help | sed -n '/Bleeping/s/[^0-9.]//gp'";
  };

  meta = {
    homepage = "https://bleep.build/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.mit;
    description = "Bleeping fast scala build tool";
    mainProgram = "bleep";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ kristianan ];
  };
})
