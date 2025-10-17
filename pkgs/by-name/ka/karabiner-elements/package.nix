{
  lib,
  stdenv,
  fetchurl,
  libarchive,
  xar,
  undmg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karabiner-elements";
  version = "15.5.0";

  src = fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-Elements/releases/download/v${finalAttrs.version}/Karabiner-Elements-${finalAttrs.version}.dmg";
    hash = "sha256-96NQxmnU1W/g2O1Ll7qsslclFzsBPnHDJ+hmNpaUUXA=";
  };

  outputs = [
    "out"
    "driver"
  ];

  nativeBuildInputs = [
    libarchive
    xar
    undmg
  ];

  unpackPhase = ''
    undmg $src
    xar -xf Karabiner-Elements.pkg
    cd Installer.pkg
    zcat Payload | bsdcpio -i
    cd ../Karabiner-DriverKit-VirtualHIDDevice.pkg
    zcat Payload | bsdcpio -i
    cd ..
  '';

  sourceRoot = ".";

  postPatch = ''
    shopt -s globstar
    for f in *.pkg/Library/**/Launch{Agents,Daemons}/*.plist; do
      substituteInPlace "$f" \
        --replace-fail "/Library/" "$out/Library/"
    done
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out $driver
    cp -R Installer.pkg/Applications Installer.pkg/Library $out
    cp -R Karabiner-DriverKit-VirtualHIDDevice.pkg/Applications Karabiner-DriverKit-VirtualHIDDevice.pkg/Library $driver

    cp "$out/Library/Application Support/org.pqrs/Karabiner-Elements/package-version" "$out/Library/Application Support/org.pqrs/Karabiner-Elements/version"
    runHook postInstall
  '';

  dontFixup = true; # notarization breaks if fixup is enabled

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/pqrs-org/Karabiner-Elements/releases/tag/v${finalAttrs.version}";
    description = "Powerful utility for keyboard customization on macOS Ventura (13) or later";
    homepage = "https://karabiner-elements.pqrs.org/";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ auscyber ];
    platforms = lib.platforms.darwin;
  };
})
