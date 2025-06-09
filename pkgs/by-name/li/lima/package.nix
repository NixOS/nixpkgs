{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  qemu,
  darwin,
  makeWrapper,
  nix-update-script,
  apple-sdk_15,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "lima";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vmn5AQpFbugFOmeiPUNMkPkgV1cZSR3nli90tdFmF0A";
  };

  vendorHash = "sha256-1+jWEZ4VvVjJ7tSL4vlkCrWxCoSu8hiXefKSm3GExNs=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.sigtool ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'codesign -f -v --entitlements vz.entitlements -s -' 'codesign -f --entitlements vz.entitlements -s -'
  '';

  # It attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  dontStrip = stdenv.hostPlatform.isDarwin;

  buildPhase = ''
    runHook preBuild
    make "VERSION=v${finalAttrs.version}" "CC=${stdenv.cc.targetPrefix}cc" binaries
    runHook postBuild
  '';

  nativeCheckInputs = [
    # Workaround for: could not create "/homeless-shelter/.lima/_config" directory: mkdir /homeless-shelter: permission denied
    writableTmpDirAsHomeHook
  ];

  installPhase =
    ''
      runHook preInstall
      mkdir -p $out
      cp -r _output/* $out
      wrapProgram $out/bin/limactl \
        --prefix PATH : ${lib.makeBinPath [ qemu ]}
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd limactl \
        --bash <($out/bin/limactl completion bash) \
        --fish <($out/bin/limactl completion fish) \
        --zsh <($out/bin/limactl completion zsh)
    ''
    + ''
      runHook postInstall
    '';

  nativeInstallCheckInputs = [
    # Workaround for: "panic: $HOME is not defined" at https://github.com/lima-vm/lima/blob/cb99e9f8d01ebb82d000c7912fcadcd87ec13ad5/pkg/limayaml/defaults.go#L53
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;

  # Don't use versionCheckHook for this package until Env solutions like #403971 or #411609 are available on the master branch.
  installCheckPhase = ''
    [[ "$("$out/bin/limactl" --version | cut -d ' ' -f 3)" == "${finalAttrs.version}" ]]
    USER=nix $out/bin/limactl validate templates/default.yaml
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/lima-vm/lima";
    description = "Linux virtual machines with automatic file sharing and port forwarding";
    changelog = "https://github.com/lima-vm/lima/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      anhduy
      kachick
    ];
  };
})
