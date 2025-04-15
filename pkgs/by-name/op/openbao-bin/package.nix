{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openbao-bin";
  version = "2.2.1";

  src = fetchurl (
    let
      sources = {
        x86_64-linux = {
          url = "https://github.com/openbao/openbao/releases/download/v${finalAttrs.version}/bao_${finalAttrs.version}_Linux_x86_64.tar.gz";
          hash = "sha256-68fLuMBZSk3ttQrnwjttLKTnlSyg0SEanKfNJZI1hzQ=";
        };
        aarch64-linux = {
          url = "https://github.com/openbao/openbao/releases/download/v${finalAttrs.version}/bao_${finalAttrs.version}_Linux_arm64.tar.gz";
          hash = "sha256-q2KAIaXmdlB59opYH0mBb6S7C/drzff6O/jkuvf8KKc=";
        };
        x86_64-darwin = {
          url = "https://github.com/openbao/openbao/releases/download/v${finalAttrs.version}/bao_${finalAttrs.version}_Darwin_x86_64.tar.gz";
          hash = "sha256-DoankvGdWsE3LoAVxWYYsEDG+W6MftuoVBzC2RxSAY0=";
        };
        aarch64-darwin = {
          url = "https://github.com/openbao/openbao/releases/download/v${finalAttrs.version}/bao_${finalAttrs.version}_Darwin_arm64.tar.gz";
          hash = "sha256-Yb+usOq9QvurbLsvPKOctVSHVqXkSf+pOTloVLdTnaQ=";
        };
      };
    in
    sources.${stdenv.hostPlatform.system}
  );

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  # Tarball does not extract to a subdirectory
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -D -m755 bao $out/bin/bao

    if [ -f LICENSE ]; then
      install -Dm644 LICENSE $out/share/licenses/openbao/LICENSE
    fi

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/bao";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.openbao.org/";
    description = "Open source, community-driven fork of Vault managed by the Linux Foundation (precompiled binary)";
    changelog = "https://github.com/openbao/openbao/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    mainProgram = "bao";
    maintainers = with lib.maintainers; [ liberodark ];
  };
})
