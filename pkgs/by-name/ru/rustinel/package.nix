{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  version = "1.3.0";

  hashes = {
    x86_64-linux = "sha256-Co3Pn9PyiFn7MDPA8wV2RttdmvvlEFjVHpCZwPBuFV0=";
    aarch64-linux = "sha256-DhV5OkCSBnHckq2cAeEjC7PwCtJU3+uorVJtHcWPNYM=";
  };

  archName =
    {
      x86_64-linux = "x86_64-unknown-linux-musl";
      aarch64-linux = "aarch64-unknown-linux-musl";
    }
    .${system};
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rustinel";
  inherit version;

  src = fetchurl {
    url = "https://github.com/Karib0u/rustinel/releases/download/v${finalAttrs.version}/rustinel-${finalAttrs.version}-${archName}.tar.gz";
    hash = hashes.${system};
  };

  sourceRoot = "rustinel-${finalAttrs.version}-${archName}";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/rustinel/rules/{sigma,yara,ioc}

    install -Dm755 rustinel $out/bin/rustinel

    cp -r rules/sigma/* $out/share/rustinel/rules/sigma/
    cp -r rules/yara/* $out/share/rustinel/rules/yara/
    cp -r rules/ioc/* $out/share/rustinel/rules/ioc/

    install -Dm644 config.toml $out/share/rustinel/config.example.toml

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source endpoint detection engine using eBPF, Sigma, YARA, and IOC matching";
    homepage = "https://github.com/Karib0u/rustinel";
    changelog = "https://github.com/Karib0u/rustinel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ yunor743 ];
    platforms = lib.attrNames hashes;
    mainProgram = "rustinel";
  };
})
