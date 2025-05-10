{
  lib,
  rustPlatform,
  fetchFromGitHub,
  autoAddDriverRunpath,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "bottom";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = "bottom";
    tag = version;
    hash = "sha256-hm0Xfd/iW+431HflvZErjzeZtSdXVb/ReoNIeETJ5Ik=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-feMgkCP6e3HsOppTYLtVrRn/vbSLLRKV0hp85gqr4qM=";

  nativeBuildInputs = [
    autoAddDriverRunpath
    installShellFiles
  ];

  postInstall = ''
    installManPage target/tmp/bottom/manpage/btm.1
    installShellCompletion \
      target/tmp/bottom/completion/btm.{bash,fish} \
      --zsh target/tmp/bottom/completion/_btm

    install -Dm444 desktop/bottom.desktop -t $out/share/applications
  '';

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/btm";

  BTM_GENERATE = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/ClementTsang/bottom/blob/${version}/CHANGELOG.md";
    description = "Cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = lib.licenses.mit;
    mainProgram = "btm";
    maintainers = with lib.maintainers; [
      berbiche
      figsoda
      gepbird
    ];
  };
}
