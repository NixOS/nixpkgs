{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  rustPlatform,
  pkg-config,
  protobuf,
  nix-update-script,
  nixosTests,
}:

let
  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
  # v2.0.0-rc.7 tag still gitignores rust/Cargo.lock; this commit adds it.
  srcRev = "b709b2bc48b8a8b42f7f616ba611c8873a927369";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qauld";
  version = "2.0.0-rc.7-unstable-2026-08-27";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "qaul";
    repo = "qaul.net";
    rev = srcRev;
    hash = "sha256-8mgIEs4D08AhPOvjIu3L+8uPo7d37x7skT72CfMkMLI=";
    # Shared with qaul: bare liblibqaul.so for DynamicLibrary.open (qaul
    # postPatch swaps the extension for the host), drop dangling iOS
    # symlink, skip in-app force-update (version is managed by Nix).
    postFetch = ''
      rm -f "$out/qaul_ui/ios/liblibqaul.a"
      substituteInPlace "$out/qaul_ui/packages/qaul_rpc/lib/src/libqaul/ffi.dart" \
        --replace-fail \
        "DynamicLibrary.open('../rust/target/\$mode/liblibqaul.so')" \
        "DynamicLibrary.open('liblibqaul.so')"
      substituteInPlace "$out/qaul_ui/lib/main.dart" \
        --replace-fail \
        "await ForceUpdateSystem.shouldForceUpdate()" \
        "(false, null)"
    '';
  };

  cargoRoot = "rust";
  buildAndTestSubdir = "rust";
  cargoHash = "sha256-wkpoeMg7vLMFlMj/ZJO+9fcqhRDj3vlMSIp5hJBl6uI=";

  patches = [
    # https://github.com/qaul/qaul.net/pull/974
    (fetchpatch2 {
      name = "exit-1-on-upgrade-failure.patch";
      url = "https://github.com/qaul/qaul.net/commit/3f1c00d116051ba7cf54fd40afc4f638b2d268b3.patch?full_index=1";
      hash = "sha256-BtNBQhvx1pc447kGapuY2lJRPuHA5lIR6+TQKnrEcm4=";
    })
  ];

  postPatch = ''
    # BLE pulls bluez D-Bus into the whole workspace via feature unification.
    substituteInPlace rust/clients/cli/Cargo.toml \
      --replace-fail \
        'libqaul = { path = "../../libqaul", features = ["rtc", "ble", "ble-encryption"] }' \
        'libqaul = { path = "../../libqaul", features = ["rtc"] }'
    # First start must mkdir data dir before writing version.
    substituteInPlace rust/libqaul/src/utilities/upgrade/mod.rs \
      --replace-fail \
        'let storage_path_buf = Path::new(&storage_path);' \
        'let storage_path_buf = Path::new(&storage_path); let _ = fs::create_dir_all(storage_path_buf);'
  '';

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  cargoBuildFlags = [
    "--workspace"
    "--exclude"
    "qaul-sim"
  ];

  # Integration-heavy; needs network and long runtime in the workspace.
  doCheck = false;

  postInstall = ''
    install -Dm755 \
      target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/liblibqaul${libExt} \
      "$out/lib/liblibqaul${libExt}"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test -f "$out/lib/liblibqaul${libExt}"
    runHook postInstallCheck
  '';

  passthru = {
    tests = {
      inherit (nixosTests) qauld;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Internet-independent wireless mesh communication daemon and CLI tools";
    homepage = "https://qaul.net";
    changelog = "https://github.com/qaul/qaul.net/blob/${srcRev}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.lucasew ];
    teams = [ lib.teams.ngi ];
    mainProgram = "qauld";
    platforms = lib.platforms.unix;
  };
})
