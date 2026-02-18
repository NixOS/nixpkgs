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
}:

let
  inherit (stdenv.hostPlatform) system;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kiro-cli";
  version = "1.26.0";

  src =
    let
      darwinDmg = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/Kiro%20CLI.dmg";
        hash = "sha256-s3//DLCh48NgJ1JdBO2oG3iT82MjTbh98a/pRCnhRhc=";
      };
    in
    {
      x86_64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-x86_64-linux.tar.gz";
        hash = "sha256-aB8snKmASQM9lOuyyvsqlF5TuJ7nFLd6OlUvfj25G9Q=";
      };
      aarch64-linux = fetchurl {
        url = "https://desktop-release.q.us-east-1.amazonaws.com/${finalAttrs.version}/kirocli-aarch64-linux.tar.gz";
        hash = "sha256-QDUgDsmUViapPViNLauAUnT/ZnlAjxxP4fnVR8+pbJE=";
      };
      x86_64-darwin = darwinDmg;
      aarch64-darwin = darwinDmg;
    }
    .${system} or (throw "Unsupported system: ${system}");

  sourceRoot = if stdenv.hostPlatform.isDarwin then "Kiro CLI.app" else "kirocli";

  strictDeps = true;

  nativeBuildInputs = [
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
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
    install -Dm755 bin/kiro-cli $out/bin/.kiro-wrapped
    install -Dm755 bin/kiro-cli-chat $out/bin/kiro-cli-chat
    install -Dm755 bin/kiro-cli-term $out/bin/kiro-cli-term
    makeBinaryWrapper $out/bin/.kiro-wrapped $out/bin/kiro \
      --prefix PATH : $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin $out/Applications
    cp -r "../Kiro CLI.app" "$out/Applications/"
    ln -s "$out/Applications/Kiro CLI.app/Contents/MacOS/kiro-cli" $out/bin/kiro
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
    maintainers = [ lib.maintainers.jamesward ];
    mainProgram = "kiro";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
