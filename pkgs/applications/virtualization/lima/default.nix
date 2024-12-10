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
}:

buildGoModule rec {
  pname = "lima";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XYB8Nxbs76xmiiZ7IYfgn+UgUr6CLOalQrl6Ibo+DRc=";
  };

  vendorHash = "sha256-nNSBwvhKSWs6to37+RLziYQqVOYfvjYib3fRRALACho=";

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

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r _output/* $out
    wrapProgram $out/bin/limactl \
      --prefix PATH : ${lib.makeBinPath [ qemu ]}
    installShellCompletion --cmd limactl \
      --bash <($out/bin/limactl completion bash) \
      --fish <($out/bin/limactl completion fish) \
      --zsh <($out/bin/limactl completion zsh)
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
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
