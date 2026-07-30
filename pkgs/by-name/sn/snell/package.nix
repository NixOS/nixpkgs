{
  lib,
  stdenv,
  fetchzip,
  upx,
  autoPatchelfHook,
  versionCheckHook,
  writeShellScript,
  nix-update,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snell-server";
  version = "5.0.1";

  src =
    let
      selectSystem = attrs: attrs.${stdenv.hostPlatform.system};
      arch = selectSystem {
        x86_64-linux = "amd64";
        aarch64-linux = "aarch64";
      };
    in
    fetchzip {
      url = "https://dl.nssurge.com/snell/snell-server-v${finalAttrs.version}-linux-${arch}.zip";
      hash = selectSystem {
        x86_64-linux = "sha256-J2kRVJRC0GhxLMarg7Ucdk8uvzTsKbFHePEflPjwsHU=";
        aarch64-linux = "sha256-UT+Rd6TEMYL/+xfqGxGN/tiSBvN8ntDrkCBj4PuMRwg=";
      };
    };

  nativeBuildInputs = [
    upx
    autoPatchelfHook
    versionCheckHook
  ];

  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  installPhase = ''
    runHook preInstall

    upx -d snell-server
    install -Dm755 snell-server $out/bin/snell-server

    runHook postInstall
  '';

  doInstallCheck = true;

  passthru.updateScript = writeShellScript "update-snell-server" ''
    latestVersion=$(curl --fail --silent https://kb.nssurge.com/surge-knowledge-base/release-notes/snell | grep -oE 'snell-server-v[0-9]+\.[0-9]+\.[0-9]+' | sed 's/snell-server-v//' | sort -V | tail -n1)
    if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then exit 0; fi
    ${lib.getExe nix-update} pkgsCross.gnu64.snell --version "$latestVersion"
    ${lib.getExe nix-update} pkgsCross.aarch64-multiplatform.snell --version skip
  '';

  meta = {
    description = "Lean encrypted proxy protocol";
    homepage = "https://kb.nssurge.com/surge-knowledge-base/release-notes/snell";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      mlyxshi
    ];
    mainProgram = "snell-server";
  };
})
