{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  qemu,
  sigtool,
  makeWrapper,
  nix-update-script,
  apple-sdk_15,
  lima,
}:

buildGoModule rec {
  pname = "lima";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "lima";
    rev = "v${version}";
    hash = "sha256-LNsxMrbEgdosGDDUNvMZq/hpP5azNiIHjKTp0Iw/PC0=";
  };

  vendorHash = "sha256-taozyQBJvkCsJAaOHg1gFK4qOnepRbzIn4jHzxfAn6A=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sigtool ];

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
    make "VERSION=v${version}" "CC=${stdenv.cc.targetPrefix}cc" binaries
    runHook postBuild
  '';

  preCheck = ''
    # Workaround for: could not create "/homeless-shelter/.lima/_config" directory: mkdir /homeless-shelter: permission denied
    export LIMA_HOME="$(mktemp -d)"
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

  doInstallCheck = true;
  # Workaround for: "panic: $HOME is not defined" at https://github.com/lima-vm/lima/blob/v1.0.2/pkg/limayaml/defaults.go#L52
  # Don't use versionCheckHook for this package. It cannot inject environment variables.
  installCheckPhase = ''
    if [[ "$(HOME="$(mktemp -d)" "$out/bin/limactl" --version | cut -d ' ' -f 3)" == "${version}" ]]; then
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
    USER=nix $out/bin/limactl validate templates/default.yaml
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/lima-vm/lima";
    description = "Linux virtual machines (on macOS, in most cases)";
    changelog = "https://github.com/lima-vm/lima/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ anhduy ];
  };
}
