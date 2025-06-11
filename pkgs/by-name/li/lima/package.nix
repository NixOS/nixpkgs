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
  withAdditionalGuestAgents ? false,
  lima-additional-guestagents,
  writableTmpDirAsHomeHook,
  testers,
  writeText,
  runCommand,
  lima,
  jq,
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

    # For checkPhase, and installPhase(required to build completion)
    writableTmpDirAsHomeHook
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.sigtool ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'codesign -f -v --entitlements vz.entitlements -s -' 'codesign -f --entitlements vz.entitlements -s -' \
      --replace-fail 'rm -rf _output vendor' 'rm -rf _output'
  '';

  # It attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  dontStrip = stdenv.hostPlatform.isDarwin;

  buildPhase =
    let
      makeFlags = [
        "VERSION=v${finalAttrs.version}"
        "CC=${stdenv.cc.targetPrefix}cc"
      ];
    in
    ''
      runHook preBuild

      make ${lib.escapeShellArgs makeFlags} native

      runHook postBuild
    '';

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

  postInstall = lib.optionalString withAdditionalGuestAgents ''
    cp -rs '${lima-additional-guestagents}/share/lima/.' "$out/share/lima/"
  '';

  nativeInstallCheckInputs = [
    # Workaround for: "panic: $HOME is not defined" at https://github.com/lima-vm/lima/blob/cb99e9f8d01ebb82d000c7912fcadcd87ec13ad5/pkg/limayaml/defaults.go#L53
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;

  # Don't use versionCheckHook for this package until Env solutions like #403971 or #411609 are available on the master branch.
  installCheckPhase = ''
    runHook preInstallCheck

    [[ "$("$out/bin/limactl" --version | cut -d ' ' -f 3)" == "${finalAttrs.version}" ]]
    USER=nix $out/bin/limactl validate templates/default.yaml

    runHook postInstallCheck
  '';

  passthru = {
    tests =
      let
        arch = stdenv.hostPlatform.parsed.cpu.name;
      in
      {
        minimalAgent = testers.testEqualContents {
          assertion = "limactl only detects host's architecture guest agent by default";
          expected = writeText "expected" ''
            true
            1
          '';
          actual =
            runCommand "actual"
              {
                nativeBuildInputs = [
                  writableTmpDirAsHomeHook
                  lima
                  jq
                ];
              }
              ''
                limactl info | jq '.guestAgents | has("${arch}")' >>"$out"
                limactl info | jq '.guestAgents | length' >>"$out"
              '';
        };

        additionalAgents = testers.testEqualContents {
          assertion = "limactl also detects additional guest agents if specified";
          expected = writeText "expected" ''
            true
            true
          '';
          actual =
            runCommand "actual"
              {
                nativeBuildInputs = [
                  writableTmpDirAsHomeHook
                  (lima.override {
                    withAdditionalGuestAgents = true;
                  })
                  jq
                ];
              }
              ''
                limactl info | jq '.guestAgents | has("${arch}")' >>"$out"
                limactl info | jq '.guestAgents | length >= 2' >>"$out"
              '';
        };
      };

    updateScript = nix-update-script { };
  };

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
