{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "orogene";
  version = "0.3.34";

  src = fetchFromGitHub {
    owner = "orogene";
    repo = "orogene";
    tag = "v${version}";
    hash = "sha256-GMWrlvZZ2xlcvcRG3u8jS8KiewHpyX0brNe4pmCpHbM=";
    fetchSubmodules = true;
  };

  cargoPatches = [
    # Workaround to avoid "error[E0282]"
    # ref: https://github.com/orogene/orogene/pull/315
    ./update-outdated-lockfile.patch
  ];

  cargoHash = "sha256-I08mqyogEuadp+V10svMmCm0i0zOZWiocOpM9E3lgag=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  preCheck = ''
    export CI=true
    export HOME=$(mktemp -d)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/oro";
  versionCheckProgramArg = "--version";

  meta = with lib; {
    description = "Package manager for tools that use node_modules";
    homepage = "https://github.com/orogene/orogene";
    changelog = "https://github.com/orogene/orogene/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      isc
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oro";
  };
}
