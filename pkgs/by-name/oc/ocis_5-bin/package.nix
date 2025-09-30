{
  fetchurl,
  lib,
  stdenv,
  autoPatchelfHook,
}:

let
  arch =
    {
      i686-linux = "386";
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
      armv7l-linux = "arm";
      x86_64-darwin = "amd64";
      aarch64-darwin = "arm64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  os =
    if stdenv.hostPlatform.isLinux then
      "linux"
    else if stdenv.hostPlatform.isDarwin then
      "darwin"
    else
      throw "Unsupported OS";

  hash =
    {
      hash_386-linux = "sha256-2RtkxtVk7YN7CfsIBpMP85g84MNTzrnEgk10eFdfyyw=";
      hash_amd64-linux = "sha256-tmUfDKLO35qCs1hauJQKhJhcnMhqOpcqDFtAggMFhLE=";
      hash_arm64-linux = "sha256-ggRDW1cnTHMQKvOvCDH3eptH3O3PgYaondlzOGHTjio=";
      hash_arm-linux = "sha256-uMLRow1NeHufSI5B4k5qSIfH3lTxg+WxzLxgdedAz40=";
      hash_amd64-darwin = "sha256-LZ6n/f2MdbFaPnBCoJqZZ7HQiLG3Z6ZoatgFsxaFvMc=";
      hash_arm64-darwin = "sha256-k5X2ZInFS/HlToOZPX23TRJqlx/XM1ZG++Xr4BHn8SY=";
    }
    ."hash_${arch}-${os}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ocis_5-bin";
  version = "5.0.9";

  src = fetchurl {
    url = "https://github.com/owncloud/ocis/releases/download/v${finalAttrs.version}/ocis-${finalAttrs.version}-${os}-${arch}";
    inherit hash;
  };

  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall
    install -D $src $out/bin/ocis
    runHook postInstall
  '';

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "ownCloud Infinite Scale Stack";
    homepage = "https://owncloud.dev/ocis/";
    changelog = "https://github.com/owncloud/ocis/releases/tag/v${finalAttrs.version}";
    # oCIS is licensed under non-free EULA which can be found here :
    # https://github.com/owncloud/ocis/releases/download/v5.0.1/End-User-License-Agreement-for-ownCloud-Infinite-Scale.pdf
    license = licenses.unfree;
    maintainers = with maintainers; [
      ramblurr
      bhankas
      danth
      ramblurr
    ];

    platforms =
      (lib.intersectLists platforms.linux (
        lib.platforms.arm ++ lib.platforms.aarch64 ++ lib.platforms.x86
      ))
      ++ (lib.intersectLists platforms.darwin (lib.platforms.aarch64 ++ lib.platforms.x86_64));

    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "ocis";
  };
})
