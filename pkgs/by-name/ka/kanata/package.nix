{
  stdenv,
  lib,
  gnused,
  rustPlatform,
  karabiner-dk,
  fetchFromGitHub,
  versionCheckHook,
  nix-update,
  yq,
  curl,
  jq,
  writeShellApplication,
  writeShellScriptBin,
  withCmd ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanata";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = "kanata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WjdmjgEMoo3QNqT4yWxaKOkfuRLdNg4Im+V1Hy5vWgY=";
  };

  cargoHash = "sha256-4UBN4I35ZPPPL68LxxPna9Fs9sATCiwoTbWgHYwqOjs=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    (writeShellScriptBin "sw_vers" ''
      echo 'ProductVersion: ${stdenv.hostPlatform.darwinMinVersion}'
    '')
  ];

  buildFeatures = lib.optional withCmd "cmd";

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  checkFlags = [
    # these try to access /dev/uinput and won't work in the build sandbox
    "--skip=kanata::tcp_layer_change_tests"
  ];

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
        nix-update
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

  meta = {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      linj
      auscyber
    ];
    platforms = lib.platforms.unix;
    mainProgram = "kanata";
  };
})
