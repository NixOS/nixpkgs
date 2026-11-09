{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  testers,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "JankyBorders";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "JankyBorders";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4hdW7JXTmSrE4bwlOkUYxA32AD011za7dmItwwIvyg=";
  };

  nativeBuildInputs = [
    pkg-config
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
    description = "Lightweight tool designed to add colored borders to user windows on macOS 14.0+";
    longDescription = "It enhances the user experience by visually highlighting the currently focused window without relying on the accessibility API, thereby being faster than comparable tools.";
    homepage = "https://github.com/FelixKratz/JankyBorders";
    changelog = "https://github.com/FelixKratz/JankyBorders/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.gpl3;
    mainProgram = "borders";
    maintainers = with lib.maintainers; [ khaneliman ];
    platforms = lib.platforms.darwin;
  };
})
