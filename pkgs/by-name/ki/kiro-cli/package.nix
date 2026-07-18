{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  undmg,
  versionCheckHook,
  xz,
  bzip2,
}:

let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kiro-cli";
  version = "2.13.0";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "sha256-8qEnlNv8lQK3SCjYJ/AdfWB/RELpjLI0VQ7n4vKA7DI=";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "sha256-uKR5ZxuijDgfIJ4DmDVhN5XGHDyOyiRkLcTie2iuzZU=";
      };
      aarch64-darwin = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/Kiro%20CLI.dmg";
        hash = "sha256-GAK8+adzrEc1kXtHVCNC1aU09C86D9mroSQv7dXvbfo=";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Kiro CLI.app" else "kirocli";

  strictDeps = true;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
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
