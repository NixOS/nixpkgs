{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "slowlorust";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "MJVL";
    repo = "slowlorust";
    rev = "refs/tags/${version}";
    hash = "sha256-c4NWkQ/QvlUo1YoV2s7rWB6wQskAP5Qp1WVM23wvV3c=";
  };

  cargoHash = "sha256-Wu1mm+yJw2SddddxC5NfnMWLr+dplnRxH3AJ1/mTAKM=";

  postPatch = ''
    # https://github.com/MJVL/slowlorust/issues/2
    substituteInPlace src/main.rs \
      --replace-fail 'version = "1.0"' 'version = "${version}"'
  '';

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "Lightweight slowloris (HTTP DoS) tool";
    homepage = "https://github.com/MJVL/slowlorust";
    changelog = "https://github.com/MJVL/slowlorust/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "slowlorust";
  };
}
