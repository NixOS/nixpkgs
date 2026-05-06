{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  pname = "appwrite-cli";
  version = "15.0.0";

  systemMap = {
    x86_64-linux = "linux-x64";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };

  hashMap = {
    x86_64-linux = "sha256-MX408tPAd1cZwak9/kaMCdfXH+dE4owbSEw/L/E75Dk=";
    aarch64-linux = "sha256-katuoi1DKIITkhs9/fj9p8o3uEZW5w2OjnK9VwRdIrU=";
    x86_64-darwin = "sha256-Nohy2lALsH/mNPVMtEZ4MDYTdF3P47k/CWAN6suaxOI=";
    aarch64-darwin = "sha256-N1yGwDRR/9X40T/QzQ1rPqbVXnk9bp6NmBtcdDdhKb8=";
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/appwrite/sdk-for-cli/releases/download/${version}/appwrite-cli-${
      systemMap.${stdenvNoCC.hostPlatform.system}
    }";
    hash =
      hashMap.${stdenvNoCC.hostPlatform.system}
        or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/appwrite
    runHook postInstall
  '';

  meta = {
    description = "Official Appwrite CLI";
    homepage = "https://appwrite.io";
    changelog = "https://github.com/appwrite/sdk-for-cli/releases/tag/${version}";
    license = lib.licenses.bsd3;
    mainProgram = "appwrite";
    maintainers = with lib.maintainers; [ mikeee ];
    platforms = lib.attrNames systemMap;
  };
}
