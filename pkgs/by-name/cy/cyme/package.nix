{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  installShellFiles,
  stdenv,
  darwin,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cyme";
  version = "2.2.11";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DRlK7QsZvydC05kHIWLR1a01/Cc+9TZN0Z4hUCfShjQ=";
  };

  cargoHash = "sha256-vh7VUTI+FKWtwYmcpEeADq/OF69M38yekPySXkFJ5ZA=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.DarwinTools
  ];

  checkFlags = [
    # doctest that requires access outside sandbox
    "--skip=udev::hwdb::get"
    # - system_profiler is not available in the sandbox
    # - workaround for "Io Error: No such file or directory"
    "--skip=test_run"
  ];

  postInstall = ''
    installManPage doc/cyme.1
    installShellCompletion --cmd cyme \
      --bash doc/cyme.bash \
      --fish doc/cyme.fish \
      --zsh doc/_cyme
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/tuna-f1sh/cyme";
    changelog = "https://github.com/tuna-f1sh/cyme/releases/tag/${finalAttrs.src.rev}";
    description = "Modern cross-platform lsusb";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ h7x4 ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin ++ lib.platforms.windows;
    mainProgram = "cyme";
  };
})
