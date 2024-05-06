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
      x86_64-linux = "sha256-Tp354ecJAZfTRrg1Rmot7nFGYfcp0ZBEn/ygTRkCBCM=";
      x86_64-darwin = "sha256-1tgFHdbrGGVofhSxJIw1oXkI6q5SJvN8L9bqRyj75j8=";
      aarch64-darwin = "sha256-UB0SoUwg9C8F8F2/CTKVNcqAofHkU7Rop04mMwBSIyY=";
    }
    ."${stdenvNoCC.system}" or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bleep";
  version = "0.0.9";

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
