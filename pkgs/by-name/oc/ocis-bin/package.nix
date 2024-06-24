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
    if stdenv.isLinux then
      "linux"
    else if stdenv.isDarwin then
      "darwin"
    else
      throw "Unsupported OS";

  hash =
    {
      hash_386-linux = "sha256-wP5ObJVhHnifPhHVWvuKZ1W1sSlEjca/MSydYjb9CTo=";
      hash_amd64-linux = "sha256-gF5RIEbWrD912kSAXiVgovZN3bGOvQDZDYkar2azpBQ=";
      hash_arm64-linux = "sha256-51MnjUea64rxgnj6P1Pl3m/VQwnDB6//uPTz8VYI93g=";
      hash_arm-linux = "sha256-5VqgcGBn9yVqfD14KPtpwBeNexHrulHAROFj5fkt57k=";
      hash_amd64-darwin = "sha256-8NizERBNlGH13pgtaSOIwYg49VSf9K9DOzngR8ng7N8=";
      hash_arm64-darwin = "sha256-qcXpUudyTMOExkqIJub6qvC4gpiawg8kOJ68qp+xm9g=";
    }
    ."hash_${arch}-${os}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ocis-bin";
  version = "6.0.0";

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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "ownCloud Infinite Scale Stack ";
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
