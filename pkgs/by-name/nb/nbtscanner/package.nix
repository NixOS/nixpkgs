{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "nbtscanner";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "jonkgrimes";
    repo = "nbtscanner";
    tag = version;
    hash = "sha256-lnTTutOc829COwfNhBkSK8UpiNnGsm7Da53b+eSBt1Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/gVJJegPIUe0Mv7+0tCP/vWrMbImtY3tb+lELnn1ur0=";

  cargoPatches = [
    ./Cargo.lock.patch
  ];

  postPatch = ''
    # https://github.com/jonkgrimes/nbtscanner/issues/4
    substituteInPlace src/main.rs \
      --replace-fail '.version("0.1")' '.version("${version}")'
  '';

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "--version" ];

  meta = with lib; {
    description = "NetBIOS scanner written in Rust";
    homepage = "https://github.com/jonkgrimes/nbtscanner";
    changelog = "https://github.com/jonkgrimes/nbtscanner/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "nbtscanner";
  };
}
