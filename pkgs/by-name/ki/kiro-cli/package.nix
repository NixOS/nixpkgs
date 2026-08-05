{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  undmg,
  versionCheckHook,
  xz,
  bzip2,
  wl-clipboard,
  # On Wayland, kiro-cli shells out to wl-clipboard (wl-copy/wl-paste) for
  # clipboard access. Enabling this puts wl-clipboard on the runtime PATH so
  # clipboard support works out of the box under Wayland sessions. Has no
  # effect on Darwin.
  waylandSupport ? stdenv.hostPlatform.isLinux,
}:

let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kiro-cli";
  version = "2.16.1";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "sha256-OTYzyZH6q172iLKqDdQgSByrf8oxLNhjkjwyh+mHS4I=";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "sha256-hBO2IHJ4B0c3TAkyFHAi4pByXpNNRh5DC1rhKnPzOyM=";
      };
      aarch64-darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/Kiro%20CLI.dmg";
        hash = "sha256-X86c+dymp08MUpFRdqZCH1lI5pA4E6+QSAxrciyyDTI=";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Kiro CLI.app" else "kirocli";

  strictDeps = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && waylandSupport) [
      makeBinaryWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      undmg
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    xz
    bzip2
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm755 bin/kiro-cli -t $out/bin
    install -Dm755 bin/kiro-cli-chat $out/bin/kiro-cli-chat
    install -Dm755 bin/kiro-cli-term $out/bin/kiro-cli-term
  ''
  + lib.optionalString (stdenv.hostPlatform.isLinux && waylandSupport) ''
    for bin in kiro-cli kiro-cli-chat kiro-cli-term; do
      wrapProgram $out/bin/$bin \
        --suffix PATH : ${lib.makeBinPath [ wl-clipboard ]}
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    cp -r "../Kiro CLI.app" "$out/Applications/"
    ln -s "$out/Applications/Kiro CLI.app/Contents/MacOS/kiro-cli" $out/bin/kiro-cli
    for bin in kiro-cli-chat kiro-cli-term; do
      if [[ -e "$out/Applications/Kiro CLI.app/Contents/MacOS/$bin" ]]; then
        ln -s "$out/Applications/Kiro CLI.app/Contents/MacOS/$bin" "$out/bin/$bin"
      fi
    done
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Command-line interface for Kiro, an agentic IDE";
    homepage = "https://kiro.dev";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [
      jamesward
      pmw
    ];
    mainProgram = "kiro-cli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
