{ lib, stdenv, fetchurl, fetchzip, autoPatchelfHook, installShellFiles, cpio, xar, _1password, testers }:

let
  inherit (stdenv.hostPlatform) system;
  fetch = srcPlatform: hash: extension:
    let
      args = {
        url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_${srcPlatform}_v${version}.${extension}";
        inherit hash;
      } // lib.optionalAttrs (extension == "zip") { stripRoot = false; };
    in
    if extension == "zip" then fetchzip args else fetchurl args;

  pname = "1password-cli";
  version = "2.30.0-beta.02";
  sources = rec {
    aarch64-linux = fetch "linux_arm64" "sha256-aGzvy3wR5B5J8ynI3e98hvaa+RsY672W1hHSpl3fppo=" "zip";
    i686-linux = fetch "linux_386" "sha256-82r3MbCpuN1FypnlkC2mc6KojYJb76JlZSFlVJVvqT8=" "zip";
    x86_64-linux = fetch "linux_amd64" "sha256-XHVwxnFTIWESdbR0FAGotW6hv58/2sx8j9I1uyIAFWg=" "zip";
    aarch64-darwin = fetch "apple_universal" "sha256-86xJ3mAJuG6bJ5USqf6rOyImhZTK1EE27SAjV7E+y4Y=" "pkg";
    x86_64-darwin = aarch64-darwin;
  };
  platforms = builtins.attrNames sources;
  mainProgram = "op";
in

stdenv.mkDerivation {
  inherit pname version;
  src =
    if (builtins.elem system platforms) then
      sources.${system}
    else
      throw "Source for ${pname} is not available for ${system}";

  nativeBuildInputs = [ installShellFiles ] ++ lib.optional stdenv.isLinux autoPatchelfHook;

  buildInputs = lib.optionals stdenv.isDarwin [ xar cpio ];

  unpackPhase = lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat op.pkg/Payload | cpio -i
  '';

  installPhase = ''
    runHook preInstall
    install -D ${mainProgram} $out/bin/${mainProgram}
    runHook postInstall
  '';

  postInstall = ''
    HOME=$TMPDIR
    installShellCompletion --cmd ${mainProgram} \
      --bash <($out/bin/${mainProgram} completion bash) \
      --fish <($out/bin/${mainProgram} completion fish) \
      --zsh <($out/bin/${mainProgram} completion zsh)
  '';

  dontStrip = stdenv.isDarwin;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/${mainProgram} --version
  '';

  passthru.updateScript = ./update.sh;

  passthru.tests.version = testers.testVersion {
    package = _1password;
  };

  meta = with lib; {
    description = "1Password command-line tool";
    homepage = "https://developer.1password.com/docs/cli/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI2";
    maintainers = with maintainers; [ joelburget ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    inherit mainProgram platforms;
  };
}
