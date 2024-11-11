{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  autoPatchelfHook,
  installShellFiles,
  cpio,
  xar,
  versionCheckHook,
}:

let
  inherit (stdenv.hostPlatform) system;
  fetch =
    srcPlatform: hash: extension:
    let
      args = {
        url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_${srcPlatform}_v${version}.${extension}";
        inherit hash;
      } // lib.optionalAttrs (extension == "zip") { stripRoot = false; };
    in
    if extension == "zip" then fetchzip args else fetchurl args;

  pname = "1password-cli";
  version = "2.30.0";
  sources = rec {
    aarch64-linux = fetch "linux_arm64" "sha256-KNduqspTzLEHmymSefLnnhIBcIQWx2tshvOc0NwDek0=" "zip";
    i686-linux = fetch "linux_386" "sha256-StdWtD3tz6bKqSem/GFqeRHzkbv4aP7d7dKKtgNhuY8=" "zip";
    x86_64-linux = fetch "linux_amd64" "sha256-bzhRkpR3te1bcBEfP2BR6SECTC9sRFDshl7B+/278Kg=" "zip";
    aarch64-darwin =
      fetch "apple_universal" "sha256-L1SZWQWjAJDZydlAttbWLS7igZNAvOmIyaUUdVbvEa8="
        "pkg";
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

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    xar
    cpio
  ];

  unpackPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
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

  dontStrip = stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;

  versionCheckProgram = "${builtins.placeholder "out"}/bin/${mainProgram}";
  versionCheckProgramArg = [ "--version" ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "1Password command-line tool";
    homepage = "https://developer.1password.com/docs/cli/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI2";
    maintainers = with maintainers; [
      joelburget
      khaneliman
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    inherit mainProgram platforms;
  };
}
