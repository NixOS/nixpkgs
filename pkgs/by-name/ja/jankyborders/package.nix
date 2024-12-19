{
  lib,
  stdenv,
  apple-sdk_11,
  fetchFromGitHub,
  pkg-config,
  testers,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "JankyBorders";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "JankyBorders";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PUyq3m244QyY7e8+/YeAMOxMcAz3gsyM1Mg/kgjGVgU=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    apple-sdk_11
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./bin/borders $out/bin/borders

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "borders-v${finalAttrs.version}";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "JankyBorders is a lightweight tool designed to add colored borders to user windows on macOS 14.0+";
    longDescription = "It enhances the user experience by visually highlighting the currently focused window without relying on the accessibility API, thereby being faster than comparable tools.";
    homepage = "https://github.com/FelixKratz/JankyBorders";
    license = lib.licenses.gpl3;
    mainProgram = "borders";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.darwin;
  };
})
