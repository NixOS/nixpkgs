{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  pkg-config,
  gtk3,
  libayatana-appindicator,
  libappindicator,
  glib,
  autoPatchelfHook,
}:
let
  cargoFlags = [
    "--bin"
    "plumeimpactor"
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impactor";
  version = "2.6.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "claration";
    repo = "Impactor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ahKJ3NRZvyLhhEYtH0fB2s7yF3HsD3WrTaA1O1knFsg=";
  };

  cargoHash = "sha256-W5AKdOjUOtggDnzKno4U40DXbComVUj0mFXRcQ8abqc=";
  doCheck = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib
    libappindicator
    libayatana-appindicator
    gtk3
  ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    libappindicator
    libayatana-appindicator
  ];

  cargoBuildFlags = cargoFlags;
  cargoTestFlags = cargoFlags;

  installPhase =
    let
      packageId = "dev.khcrysalis.PlumeImpactor";
      targetDir = "target/${stdenv.hostPlatform.rust.rustcTarget}/${finalAttrs.cargoBuildType}/";
    in
    lib.concatStringsSep "\n" [
      "runHook preInstall"
      (lib.optionalString stdenv.hostPlatform.isDarwin ''
        mkdir -p dist/Impactor.app/Contents/MacOS
        cp -R package/macos/Impactor.app dist/Impactor.app

        cp ${targetDir}/plumeimpactor dist/Impactor.app/Contents/MacOS/Impactor
        chmod +x dist/Impactor.app/Contents/MacOS/Impactor
        strip dist/Impactor.app/Contents/MacOS/Impactor

        /usr/libexec/PlistBuddy dist/Impactor.app/Contents/Info.plist <<EOF
        Set :CFBundleShortVersionString ${finalAttrs.version}
        Set :CFBundleVersion ${finalAttrs.version}
        Save
        EOF

        mkdir -p $out/Applications/Impactor.app
        cp -R dist/Impactor.app $out/Applications/Impactor.app
      '')
      (lib.optionalString stdenv.hostPlatform.isLinux ''
        install -Dm755 ${targetDir}/plumeimpactor $out/bin/plumeimpactor

        install -Dm644 package/linux/${packageId}.desktop $out/share/applications/${packageId}.desktop
        install -Dm644 package/linux/icons/hicolor/16x16/apps/${packageId}.png $out/share/icons/hicolor/16x16/apps/${packageId}.png
        install -Dm644 package/linux/icons/hicolor/32x32/apps/${packageId}.png $out/share/icons/hicolor/32x32/apps/${packageId}.png
        install -Dm644 package/linux/icons/hicolor/48x48/apps/${packageId}.png $out/share/icons/hicolor/48x48/apps/${packageId}.png
        install -Dm644 package/linux/icons/hicolor/64x64/apps/${packageId}.png $out/share/icons/hicolor/64x64/apps/${packageId}.png
        install -Dm644 package/linux/icons/hicolor/128x128/apps/${packageId}.png $out/share/icons/hicolor/128x128/apps/${packageId}.png
        install -Dm644 package/linux/icons/hicolor/256x256/apps/${packageId}.png $out/share/icons/hicolor/256x256/apps/${packageId}.png
        install -Dm644 package/linux/icons/hicolor/512x512/apps/${packageId}.png $out/share/icons/hicolor/512x512/apps/${packageId}.png
      '')
      "runHook postInstall"
    ];

  meta = {
    description = "Cross-platform iOS/iPadOS/tvOS sideloading application";
    homepage = "https://impactor.claration.dev/";
    downloadPage = "https://impactor.claration.dev/download/";
    donationPage = "https://github.com/sponsors/claration";
    mainProgram = "impactor";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ paige ];
    license = with lib.licenses; [
      mit
      bsd3
    ];
  };
})
