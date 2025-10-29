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
  version = "2.32.0";
  sources = rec {
    aarch64-linux = fetch "linux_arm64" "sha256-7t8Ar6vF8lU3fPy5Gw9jtUkcx9gYKg6AFDB8/3QBvbk=" "zip";
    i686-linux = fetch "linux_386" "sha256-+KSi87muDH/A8LNH7iDPQC/CnZhTpvFNSw1cuewqaXI=" "zip";
    x86_64-linux = fetch "linux_amd64" "sha256-4I7lSey6I4mQ7dDtuOASnZzAItFYkIDZ8UMsqb0q5tE=" "zip";
    aarch64-darwin =
      fetch "apple_universal" "sha256-PVSI/iYsjphNqs0DGQlzRhmvnwj4RHcNODE2nbQ8CO0="
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
  versionCheckProgramArg = "--version";

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
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    inherit mainProgram platforms;
  };
}
