{
  stdenv,
  lib,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  jq,
  moreutils,
  versionCheckHook,
  nix-update-script,
  withCmd ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cG9so0x0y8CbTxLOxSQwn5vG72KxHJzzTIH4lQA4MvE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VKvle1hQae+0Vbvd7Epq3cDqG8OV5J2mowF5lue59oc=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.IOKit ];

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
    broken = stdenv.hostPlatform.isDarwin;
  };
}
