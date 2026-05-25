{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  installShellFiles,
  versionCheckHook,
  runCommand,
}:
let
  sources = lib.importJSON ./sources.json;
  platform =
    sources.platforms.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported platform: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "swiftlint";
  inherit (sources) version;

  src = fetchurl {
    url = "https://github.com/realm/SwiftLint/releases/download/${finalAttrs.version}/${platform.filename}";
    inherit (platform) hash;
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    unzip
    installShellFiles
  ];

  sourceRoot = ".";

  installPhase =
    let
      binary = if stdenvNoCC.hostPlatform.isLinux then "swiftlint-static" else "swiftlint";
    in
    ''
      runHook preInstall
      install -Dm755 ${binary} $out/bin/swiftlint
      runHook postInstall
    '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd swiftlint \
      --bash <($out/bin/swiftlint --generate-completion-script bash) \
      --fish <($out/bin/swiftlint --generate-completion-script fish) \
      --zsh <($out/bin/swiftlint --generate-completion-script zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = ./update.sh;
    tests = {
      lint =
        runCommand "swiftlint-test-lint"
          {
            nativeBuildInputs = [ finalAttrs.finalPackage ];
          }
          ''
            printf "class test{}\n\nvar a = 1" > test.swift
            swiftlint lint ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin "--disable-sourcekit"} test.swift > output.txt 2>&1 || true
            grep -q "identifier_name" output.txt
            grep -q "opening_brace" output.txt
            grep -q "trailing_newline" output.txt
            grep -q "type_name" output.txt
            touch $out
          '';
    };
  };

  meta = {
    description = "Tool to enforce Swift style and conventions";
    homepage = "https://realm.github.io/SwiftLint/";
    license = lib.licenses.mit;
    mainProgram = "swiftlint";
    maintainers = with lib.maintainers; [
      matteopacini
      DimitarNestorov
    ];
    platforms = lib.attrNames sources.platforms;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
