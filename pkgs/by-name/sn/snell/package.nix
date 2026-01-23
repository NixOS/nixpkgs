{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  upx,
}:
let
  platformMap = {
    "x86_64-linux" = "linux-amd64";
    "aarch64-linux" = "linux-aarch64";
  };
  system = stdenv.hostPlatform.system;
  platform = platformMap.${system} or (throw "Unsupported platform: ${system}");
  hashs = {
    "x86_64-linux" = "sha256-J2kRVJRC0GhxLMarg7Ucdk8uvzTsKbFHePEflPjwsHU=";
    "aarch64-linux" = "sha256-UT+Rd6TEMYL/+xfqGxGN/tiSBvN8ntDrkCBj4PuMRwg=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "snell-server";
  version = "5.0.1";

  src = fetchzip {
    url = "https://dl.nssurge.com/snell/snell-server-v${finalAttrs.version}-${platform}.zip";
    hash = hashs.${system};
  };

  nativeBuildInputs = [
    upx
    autoPatchelfHook
  ];
  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];
  installPhase = ''
    runHook preInstall
    upx -d snell-server
    install -Dm755 snell-server $out/bin/snell-server
    runHook postInstall
  '';

  meta = {
    description = "Lean encrypted proxy protocol";
    homepage = "https://kb.nssurge.com/surge-knowledge-base/release-notes/snell";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames platformMap;
    maintainers = with lib.maintainers; [
      mlyxshi
    ];
    mainProgram = "snell-server";
  };
})
