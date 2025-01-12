{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  writeShellApplication,
  curl,
  cacert,
  gnugrep,
  common-updater-scripts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "rapidapi";
  version = "4.2.8-4002008002";

  src = fetchurl {
    url = "https://cdn-builds.paw.cloud/paw/RapidAPI-${finalAttrs.version}.zip";
    hash = "sha256-ApBOYMOjpQJvUe+JsEAnyK7xpIZNt6qkX/2KUIT6S8g=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = "RapidAPI.app";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "rapidapi-update-script";
    runtimeInputs = [
      curl
      cacert
      gnugrep
      common-updater-scripts
    ];
    text = ''
      url="https://paw.cloud/download"
      version=$(curl -Ls -o /dev/null -w "%{url_effective}" "$url" | grep -oP '\d+\.\d+\.\d+-\d+')
      update-source-version rapidapi "$version"
    '';
  });

  meta = {
    description = "Full-featured HTTP client that lets you test and describe the APIs you build or consume";
    homepage = "https://paw.cloud";
    changelog = "https://paw.cloud/updates/${lib.head (lib.splitString "-" finalAttrs.version)}";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
