{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  stdenv,
  darwin,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cyme";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "tuna-f1sh";
    repo = "cyme";
    rev = "v${version}";
    hash = "sha256-KAHCeM1rAPGi98PrcVJtzkhTWGWFwf37VuSQTjqXSEg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-LwBTDBrsigt8H6PFuuGndiMlj5d8v68dyHipVYOGKVk=";

  nativeBuildInputs =
    [
      pkg-config
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = [ "--version" ];

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
