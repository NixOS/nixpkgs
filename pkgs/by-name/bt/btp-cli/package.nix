{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
  makeBinaryWrapper,
  autoPatchelfHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  inherit (stdenv.hostPlatform) system;

  manifest = lib.importJSON ./manifest.json;
  platformManifestEntry = manifest.platforms.${system};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "btp-cli";
  inherit (manifest) version;

  src = fetchurl {
    url = platformManifestEntry.url;
    sha256 = platformManifestEntry.hash;
    curlOptsList = [
      "--cookie"
      "eula_3_2_agreed=tools.hana.ondemand.com/developer-license-3_2.txt"
    ];
    meta.license = lib.licenses.unfree;
  };

  dontBuild = true;

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isElf [ autoPatchelfHook ];

  strictDeps = true;
  __structuredAttrs = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd btp \
      --bash <($out/bin/btp --autocomplete=init:bash) \
      --zsh  <($out/bin/btp --autocomplete=init:zsh)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./btp $out/bin/btp

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = ./update.py;

  meta = {
    description = "CLI tool for the SAP Business Technology Platform";
    homepage = "https://tools.hana.ondemand.com/#cloud-btpcli";
    license = {
      fullName = "SAP Developer License";
      free = false;
      url = "https://tools.hana.ondemand.com/developer-license-3_2.txt";
    };
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = lib.attrNames manifest.platforms;
    maintainers = [ ];
    mainProgram = "btp";
  };
})
