{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  versionCheckHook,
}:

let
  inherit (stdenv.hostPlatform) system;
  version = "1.5.0";

  sources = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-aarch64-apple-darwin.tar.xz";
      hash = "sha256-OnN+mH+tkmvquzHNFucdHvHtZPUu9MpF1lFJEyl44MU=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-x86_64-apple-darwin.tar.xz";
      hash = "sha256-vvmKcv/vdIuyFHeDLtB6qSNKzfR+azncO11tLOaW9hc=";
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-aarch64-unknown-linux-gnu.tar.xz";
      hash = "sha256-sSek63aVfTcFRnmRdLJAA5moEDW++vvpMHbV7M17DXY=";
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-x86_64-unknown-linux-gnu.tar.xz";
      hash = "sha256-xd5D7r+HbrD5+C/5SfDhDq2hk533Cznoe1KUKsMI9wQ=";
    };
  };

  platforms = builtins.attrNames sources;
in

stdenv.mkDerivation {
  pname = "linear-cli";
  inherit version;

  src =
    if (builtins.elem system platforms) then
      sources.${system}
    else
      throw "Source for linear-cli is not available for ${system}";

  sourceRoot =
    let
      platformSuffix = {
        aarch64-darwin = "aarch64-apple-darwin";
        x86_64-darwin = "x86_64-apple-darwin";
        aarch64-linux = "aarch64-unknown-linux-gnu";
        x86_64-linux = "x86_64-unknown-linux-gnu";
      };
    in
    "linear-${platformSuffix.${system}}";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  installPhase = ''
    runHook preInstall
    install -Dm755 linear $out/bin/linear
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd linear \
      --bash <($out/bin/linear completions bash) \
      --fish <($out/bin/linear completions fish) \
      --zsh <($out/bin/linear completions zsh)
  '';

  dontStrip = stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/linear";

  meta = {
    description = "CLI for Linear issue tracker - list, start, and create PRs for issues";
    homepage = "https://github.com/schpet/linear-cli";
    changelog = "https://github.com/schpet/linear-cli/blob/main/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jupblb ];
    mainProgram = "linear";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    inherit platforms;
  };
}
