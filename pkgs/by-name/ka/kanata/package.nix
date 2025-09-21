{
  stdenv,
  lib,
  apple-sdk_13,
  darwinMinVersionHook,
  rustPlatform,
  runCommand,
  karabiner-dk,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writeShellScriptBin,
  jq,
  withCmd ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanata";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = "kanata";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-xxAIwiwCQugDXpWga9bQ9ZGfem46rwDlmf64dX/tw7g=";
  };

  cargoHash = "sha256-LfjuQHR3vVUr2e0efVymnfCnyYkFRx7ZiNdSIjBZc5s=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk_13
    (darwinMinVersionHook "13.0")
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    (writeShellScriptBin "sw_vers" ''
      echo 'ProductVersion: 13.0'
    '')
  ];
  buildFeatures = lib.optional withCmd "cmd";

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    updateScript = nix-update-script { };
    darwinDriver = lib.optional stdenv.hostPlatform.isDarwin (
      karabiner-dk.override ({
        driver-version = builtins.readFile "${
          runCommand "darwin-driver-version" { } ''
            DRIVER_FOLDER="$(find "${finalAttrs.cargoDeps}" -type d -name "karabiner-driverkit-*" )"
            cat "$DRIVER_FOLDER/c_src/Karabiner-DriverKit-VirtualHIDDevice/version.json" | ${lib.getExe jq} --raw-output .package_version | tr -d '\n' > $out
          ''

        }";
      })
    );
  };

  meta = with lib; {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      bmanuel
      linj
    ];
    platforms = platforms.unix;
    mainProgram = "kanata";
  };
})
