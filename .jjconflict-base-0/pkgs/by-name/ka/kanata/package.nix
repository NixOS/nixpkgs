{
  stdenv,
  lib,
  apple-sdk_13,
  darwinMinVersionHook,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  writeShellScriptBin,
  withCmd ? false,
}:
rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = "kanata";
    rev = "v${version}";
    sha256 = "sha256-w/PeSqj51gJOWmAV5UPMprntdzinX/IL49D2ZUMfeSM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-T9fZxv3aujYparzVphfYBJ+5ti/T1VkeCeCqWPyllY8=";

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
}
