{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  nix-update-script,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation rec {
  pname = "swiftlint";
  version = "0.57.1";

  src = fetchurl {
    url = "https://github.com/realm/SwiftLint/releases/download/${version}/portable_swiftlint.zip";
    hash = "sha256-qi4Pj4JyVF5Vk+vt14cttREy/OxOrXbQAbvhevaceuU=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 swiftlint $out/bin/swiftlint
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A tool to enforce Swift style and conventions";
    homepage = "https://realm.github.io/SwiftLint/";
    license = lib.licenses.mit;
    mainProgram = "swiftlint";
    maintainers = with lib.maintainers; [
      matteopacini
      DimitarNestorov
    ];
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
