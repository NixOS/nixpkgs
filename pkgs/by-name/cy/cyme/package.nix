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

rustPlatform.buildRustPackage rec {
  pname = "cyme";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-StvkMo9HZzAx3T+dnRQBUZJOC3EOj+ItqO13vW+F/SU=";
  };

  cargoHash = "sha256-roLuOVkBSDZ+2bHEcA53CcdtE82EO4/anCvlVHeTC0s=";

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
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/tuna-f1sh/cyme";
    changelog = "https://github.com/tuna-f1sh/cyme/releases/tag/${src.rev}";
    description = "Modern cross-platform lsusb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.linux ++ platforms.darwin ++ platforms.windows;
    mainProgram = "cyme";
  };
}
