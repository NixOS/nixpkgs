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
      }
      // lib.optionalAttrs (extension == "zip") { stripRoot = false; };
    in
    if extension == "zip" then fetchzip args else fetchurl args;

  pname = "1password-cli";
  version = "2.34.0";
  sources = rec {
    aarch64-linux = fetch "linux_arm64" "sha256-LuOI9r1VRnL9IGsK4vy4ENOS64xdpIZ+ZskIkUJ0s34=" "zip";
    i686-linux = fetch "linux_386" "sha256-VvqEyDHEIY3BsgubiJKXql1WEnwXHkSHpFvCcKBIeYw=" "zip";
    x86_64-linux = fetch "linux_amd64" "sha256-sbydXPoT0Vo3r2gyZBdl4OMtOejbhvra5JM4wB6Ex5s=" "zip";
    aarch64-darwin =
      fetch "apple_universal" "sha256-9h+Z7INYcJcWeVQ9QnXKjtT5QyV2J+dP857qSOpBAy8="
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
      throw "Source for 1password-cli is not available for ${system}";

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    xar
    cpio
  ];

  unpackPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    xar -xf $src
    zcat op.pkg/Payload | cpio -i
  '';

  installPhase = ''
    runHook preInstall
    install -D op $out/bin/op
    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    HOME=$TMPDIR
    installShellCompletion --cmd op \
      --bash <($out/bin/op completion bash) \
      --fish <($out/bin/op completion fish) \
      --zsh <($out/bin/op completion zsh)
  '';

  dontStrip = stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;

  versionCheckProgram = "${placeholder "out"}/bin/op";

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "1Password command-line tool";
    homepage = "https://developer.1password.com/docs/cli/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI2";
    maintainers = with lib.maintainers; [
      joelburget
      khaneliman
      savtrip
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    inherit mainProgram platforms;
  };
}
