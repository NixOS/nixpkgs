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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = "kanata";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-IicVuJZBHzBv9SNGQuWIIaLq2qpWfn/jMFh9KPvAThs=";
  };

  cargoHash = "sha256-2DTL1u17jUFiRoVe7973L5/352GtKte/vakk01SSRwY=";

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
    darwinDriverVersion = "6.2.0"; # needs to be updated if karabiner-driverkit changes
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
