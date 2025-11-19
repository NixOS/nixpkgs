{
  stdenv,
  lib,
  gnused,
  rustPlatform,
  karabiner-dk,
  fetchFromGitHub,
  versionCheckHook,
  common-updater-scripts,
  yq,
  curl,
  jq,
  writeShellApplication,
  writeShellScriptBin,
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

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    (writeShellScriptBin "sw_vers" ''
      echo 'ProductVersion: ${stdenv.hostPlatform.darwinMinVersion}'
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
    darwinDriverVersion = "5.0.0"; # needs to be updated if karabiner-driverkit changes
    updateScript = lib.getExe (writeShellApplication {
      name = "update-script-kanata";
      runtimeInputs = [
        curl
        gnused
        yq
        jq
        common-updater-scripts
      ];
      text = builtins.readFile ./update.sh;
    });

    darwinDriver =
      if stdenv.hostPlatform.isDarwin then
        (karabiner-dk.override {
          driver-version = finalAttrs.passthru.darwinDriverVersion;
        })
      else
        null;
  };

  meta = with lib; {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      linj
      auscyber
    ];
    platforms = platforms.unix;
    mainProgram = "kanata";
  };
})
