{
  stdenvNoCC,
  fetchzip,
  autoPatchelfHook,
  installShellFiles,
  makeWrapper,
  lib,
  zlib,
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
      x86_64-linux = "sha256-IgdIYQffNj2L3NQvP/no7ax1FQQ/FMPOAuUwQUCK1Cs=";
      x86_64-darwin = "sha256-h8TlNCRUFOGGffnoVshKXIjC+ZlhB76dGMLYvEQdspA=";
      aarch64-darwin = "sha256-tzjYmyBTwCt1ibUgfEsjr6RsLCumaURerw8c79LdzsI=";
    }
    ."${stdenvNoCC.system}" or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bleep";
  version = "0.0.8";

  src = fetchzip {
    url = "https://github.com/oyvindberg/bleep/releases/download/v${finalAttrs.version}/bleep-${platform}.tar.gz";
    hash = hash;
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ] ++ lib.optional stdenvNoCC.isLinux autoPatchelfHook;

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 bleep -t $out/bin/
    runHook postInstall
  '';

  dontAutoPatchelf = true;

  postFixup =
    lib.optionalString stdenvNoCC.isLinux ''
      autoPatchelf $out
    ''
    + ''
      export PATH=$PATH:$out/bin
      installShellCompletion --cmd bleep \
        --bash <(bleep install-tab-completions-bash --stdout) \
        --zsh <(bleep install-tab-completions-zsh --stdout) \
    '';

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
