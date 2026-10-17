{
  apple-sdk,
  darwin,
  fetchFromGitHub,
  fetchSwiftPMDeps,
  installShellFiles,
  jq,
  lib,
  nix-update-script,
  stdenv,
  swift,
  swiftpm,
  testers,
  versionCheckHook,
  zsh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mas";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "mas-cli";
    repo = "mas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HauB/3kDR5q8Dug9VLPJGPonUG5dtPY0mr3QyLplfNQ=";
  };

  swiftpmDeps = fetchSwiftPMDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-cY/139jvYr3uhlA1bSAhpospNV9feoc68l658cCUJls=";
  };

  patches = [ ./nix-build.patch ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    apple-sdk.privateFrameworksHook
    darwin.sigtool
    installShellFiles
    swift
    swiftpm
  ];

  postPatch = ''
    # Swift Testing must use at least the toolchain's deployment target.
    substituteInPlace Package.swift \
      --replace-fail '.macOS(.v13)' '.macOS("${stdenv.hostPlatform.darwinMinVersion}")'

    # Source archives have no Git metadata; generate fixed build information.
    cat > Sources/mas/MAS+BuildInfo.swift <<'EOF'
    extension MAS {
      static let version = "${finalAttrs.version}"
      static let distribution = "nixpkgs"
      static let gitOrigin = "https://github.com/mas-cli/mas"
      static let gitRevision = "${finalAttrs.src.tag}"
      static let swiftVersion = "${swift.version}"
      static let swiftDriverVersion = "${swift.version}"
    }
    EOF
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    # Use the upstream test script with its default debug configuration.
    # Supply the version because source archives have no Git metadata.
    flagsArray=()
    concatTo flagsArray swiftpmFlags swiftpmFlagsArray
    MAS_VERSION=${finalAttrs.version} ${lib.getExe zsh} -Ndefgku Scripts/test \
      --disable-sandbox -j "$NIX_BUILD_CORES" \
      -Xswiftc -module-cache-path -Xswiftc "$NIX_BUILD_TOP/module-cache" \
      "''${flagsArray[@]}"

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    installBin Scripts/mas
    install -D --mode=755 "$(swiftpmBinPath)/mas" "$out/libexec/bin/mas"

    substituteInPlace "$out/bin/mas" \
      --replace-fail "#!/bin/zsh" "#!${lib.getExe zsh}" \
      --replace-fail "/usr/bin/jq" "${lib.getExe jq}"

    swift package --disable-sandbox generate-manual \
      --date "$(date -u -d "@$SOURCE_DATE_EPOCH" +%F)"
    installManPage .build/plugins/GenerateManual/outputs/mas/mas.1
    installShellCompletion --bash contrib/completion/mas.bash
    installShellCompletion --fish contrib/completion/mas.fish

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Exercise the wrapper's jq pipeline without making an App Store request.
    "$out/bin/mas" lookup --help > lookup-help.txt
    grep -F 'USAGE: mas lookup' lookup-help.txt

    runHook postInstallCheck
  '';

  passthru.tests.lookup = testers.runCommand {
    name = "mas-test-lookup";
    script = ''
      # Query Xcode without an App Store account or installing anything.
      ${lib.getExe finalAttrs.finalPackage} lookup 497799835 > lookup.txt
      grep -E '^App .* Xcode$' lookup.txt

      touch "$out"
    '';
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--subpackage=swiftpmDeps.vendorStaging" ];
  };

  meta = {
    description = "Mac App Store command line interface";
    homepage = "https://github.com/mas-cli/mas";
    license = lib.licenses.mit;
    mainProgram = "mas";
    maintainers = with lib.maintainers; [
      zachcoyle
      tiferrei
      kinnrai
    ];
    platforms = [
      "aarch64-darwin"
    ];
  };
})
