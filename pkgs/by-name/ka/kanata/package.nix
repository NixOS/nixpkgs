{
  stdenv,
  lib,
  gnused,
  rustPlatform,
  karabiner-dk,
  fetchFromGitHub,
  versionCheckHook,
<<<<<<< HEAD
  nix-update,
=======
  common-updater-scripts,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  yq,
  curl,
  jq,
  writeShellApplication,
  writeShellScriptBin,
  withCmd ? false,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kanata";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = "kanata";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    sha256 = "sha256-jzTK/ZK9UrXTP/Ow662ENBv3cim6klA8+DQv4DLVSNU=";
  };

  cargoHash = "sha256-qYFt/oHokR+EznugEaE/ZEn26IFVLXePgoYGxoPRi+g=";
=======
    sha256 = "sha256-xxAIwiwCQugDXpWga9bQ9ZGfem46rwDlmf64dX/tw7g=";
  };

  cargoHash = "sha256-LfjuQHR3vVUr2e0efVymnfCnyYkFRx7ZiNdSIjBZc5s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    darwinDriverVersion = "6.2.0"; # needs to be updated if karabiner-driverkit changes
=======
    darwinDriverVersion = "5.0.0"; # needs to be updated if karabiner-driverkit changes
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    updateScript = lib.getExe (writeShellApplication {
      name = "update-script-kanata";
      runtimeInputs = [
        curl
        gnused
        yq
        jq
<<<<<<< HEAD
        nix-update
=======
        common-updater-scripts
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [
      linj
      auscyber
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [
      linj
      auscyber
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "kanata";
  };
})
