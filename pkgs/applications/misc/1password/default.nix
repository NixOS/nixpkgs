{ lib, stdenvNoCC, fetchurl, fetchzip, autoPatchelfHook, installShellFiles, _1password, testers, darwin }:

let
  inherit (stdenvNoCC.hostPlatform) system;
  fetch = srcPlatform: hash: extension:
    let
      args = {
        url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${version}/op_${srcPlatform}_v${version}.${extension}";
        inherit hash;
      } // lib.optionalAttrs (extension == "zip") { stripRoot = false; };
    in
    if extension == "zip" then fetchzip args else fetchurl args;

  pname = "1password-cli";
  version = "2.25.0";
  sources = rec {
    aarch64-linux = fetch "linux_arm64" "sha256-Fs7psSWGqQqnUpGtU0nv1Mv+GysL/wD8AeVbMUDJ9pg=" "zip";
    i686-linux = fetch "linux_386" "sha256-Vqk2COKRtDkOn7960VknyHx7sZVHZ4GP+aaC1rU4eqc=" "zip";
    x86_64-linux = fetch "linux_amd64" "sha256-rMIZU92A13eiUqr35C+RTg3OTE9u8hcYJRinHoPWYTE=" "zip";
    aarch64-darwin = fetch "apple_universal" "sha256-JO7Hh8PUnW5D3GCJFPcVfIYXzHV6HkckqFnGK9vH7Qs=" "pkg";
    x86_64-darwin = aarch64-darwin;
  };
  platforms = builtins.attrNames sources;

  src =
    if (builtins.elem system platforms) then
      sources.${system}
    else
      throw "Source for ${pname} is not available for ${system}";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -D ${meta.mainProgram} $out/bin/${meta.mainProgram}
    runHook postInstall
  '';

  postInstall = ''
    HOME=$TMPDIR
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} completion bash) \
      --fish <($out/bin/${meta.mainProgram} completion fish) \
      --zsh <($out/bin/${meta.mainProgram} completion zsh)
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/${meta.mainProgram} --version
  '';

  testers' = testers.testVersion {
    package = _1password;
  };

  meta = with lib; {
    description = "1Password command-line tool";
    homepage = "https://developer.1password.com/docs/cli/";
    downloadPage = "https://app-updates.agilebits.com/product_history/CLI2";
    maintainers = with maintainers; [ joelburget marsam ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    mainProgram = "op";
    inherit platforms;
  };

  linux = stdenvNoCC.mkDerivation {
    inherit pname version src installPhase postInstall doInstallCheck installCheckPhase meta;
    nativeBuildInputs = nativeBuildInputs ++ [ autoPatchelfHook ];
    passthru.tests.version = testers';
  };

  darwin' = darwin.installBinaryPackage {
    inherit pname version src nativeBuildInputs installPhase postInstall doInstallCheck installCheckPhase meta;
    passthru.tests.version = testers';
  };
in
if stdenvNoCC.isDarwin
then darwin'
else linux
