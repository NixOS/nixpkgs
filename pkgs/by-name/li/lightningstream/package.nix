{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "lightningstream";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "PowerDNS";
    repo = "lightningstream";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9RJOPNiso7RjjlzeRCjR6hl/er7g72oLvOqTAA+B4oc=";
  };

  postPatch = ''
    substituteInPlace cmd/lightningstream/commands/version.go \
      --replace-fail 'bi.Main.Version' '"${finalAttrs.version}"'
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  vendorHash = "sha256-19WrmUuUxkhvH8gLtGAghMUX9cjUpY4Go4KPGKwJjB0=";

  nativeBuildInputs = [ installShellFiles ];

  # Install shell completions so long as we can run the binary to do so. This means that
  # when cross compiling we may not be able to generate shell completions.
  # See https://github.com/NixOS/nixpkgs/issues/308283
  #
  # Dummy config file is currently required to generate completions. This may be fixed
  # upstream; see https://github.com/PowerDNS/lightningstream/issues/85
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    cat <<END > lightningstream.yaml
    lmdbs:
      dummy:
        path: dummy
    END

    installShellCompletion \
      --cmd lightningstream \
      --bash <($out/bin/lightningstream completion bash) \
      --fish <($out/bin/lightningstream completion fish) \
      --zsh <($out/bin/lightningstream completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "LMDB sync via S3 buckets";
    mainProgram = "lightningstream";
    license = lib.licenses.mit;
    changelog = "https://github.com/PowerDNS/lightningstream/releases/tag/v${finalAttrs.version}";
    homepage = "https://doc.powerdns.com/lightningstream/latest/index.html";
    maintainers = with lib.maintainers; [ samw ];
  };
})
