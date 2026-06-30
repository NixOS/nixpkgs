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
      hash_386-linux = "sha256-fO/bdIj6Ez98ICjDN2r98ADsc+QxOKwcry5XfArNA54=";
      hash_amd64-linux = "sha256-l+x+pd95nDznGu7i7PQr6v56bA4ajO2Q+SE/8XYBMPc=";
      hash_arm64-linux = "sha256-jSbFMSAGwGcjuGPrbzHyh84Ww8LHStXw2oL3Y66j1H4=";
      hash_arm-linux = "sha256-gyhquYsyuEIASjF51so6tE7iauP/Gk21jpZ2+iHICAQ=";
      hash_amd64-darwin = "sha256-yIVi/yi0mzYTvWQ8MeRgKDLvX4ye+GnlDSrNqTWwh3w=";
      hash_arm64-darwin = "sha256-ryQvmTDq5M/MOXNj+ePS1lMwiTSpT/Z1oGhkuYst6dE=";
    }
    ."hash_${arch}-${os}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ocis_71-bin";
  version = "7.1.4";

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
