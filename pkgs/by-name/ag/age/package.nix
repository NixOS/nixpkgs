{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  age-plugin-fido2-hmac,
  age-plugin-ledger,
  age-plugin-se,
  age-plugin-sss,
  age-plugin-tpm,
  age-plugin-yubikey,
  age-plugin-1p,
  makeWrapper,
  runCommand,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "age";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A1VUzovKWxwelSc9/xofBwTfbRil9t75fRavb5p2JlA=";
  };

  vendorHash = "sha256-cNh9U7OjoxewskX/+Ezln+U7p44g2h+Zx1dVKAaK6Ww=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  preInstall = ''
    installManPage doc/*.1
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  # plugin test is flaky, see https://github.com/FiloSottile/age/issues/517
  checkFlags = [
    "-skip"
    "TestScript/plugin"
  ];

  # group age plugins together
  passthru.plugins = {
    inherit
      age-plugin-fido2-hmac
      age-plugin-ledger
      age-plugin-se
      age-plugin-sss
      age-plugin-tpm
      age-plugin-yubikey
      age-plugin-1p
      ;
  };

  # convenience function for wrapping sops with plugins
  passthru.withPlugins =
    filter:
    runCommand "age-${finalAttrs.version}-with-plugins" { nativeBuildInputs = [ makeWrapper ]; } ''
      makeWrapper ${lib.getBin finalAttrs.finalPackage}/bin/age $out/bin/age \
        --prefix PATH : "${lib.makeBinPath (filter finalAttrs.passthru.plugins)}"
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/FiloSottile/age/releases/tag/v${finalAttrs.version}";
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = lib.licenses.bsd3;
    mainProgram = "age";
    maintainers = with lib.maintainers; [ tazjin ];
  };
})
