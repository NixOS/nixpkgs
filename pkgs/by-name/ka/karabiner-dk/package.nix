{
  libarchive,
  xar,
  lib,
  stdenv,
  fetchFromGitHub,
  common-updater-scripts,
  writeShellScript,
  curl,
  jq,
  driver-version ? null,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "karabiner-dk";
  sourceVersion = "6.6.0";
  version = lib.defaultTo finalAttrs.sourceVersion driver-version;

  src = fetchFromGitHub {
    owner = "pqrs-org";
    repo = "Karabiner-DriverKit-VirtualHIDDevice";
    tag = "v${finalAttrs.sourceVersion}";
    hash = "sha256-e4hdP70tb3qyrcplZbDjMlPj4OnX6EdBBJWAgjZCtuM=";
  };

  nativeBuildInputs = [
    libarchive
    xar
  ];

  unpackPhase = ''
    runHook preUnpack
    xar -xf $src/dist/Karabiner-DriverKit-VirtualHIDDevice-${finalAttrs.version}.pkg
    zcat Payload | bsdcpio -i
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R ./Applications ./Library $out
    runHook postInstall
  '';
  dontFixup = true;

  passthru.updateScript = writeShellScript "karabiner-dk" ''
    NEW_VERSION=$(${lib.getExe curl} --silent https://api.github.com/repos/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/latest $${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} | ${lib.getExe jq} '.tag_name | ltrimstr("v")' --raw-output)
    ${lib.getExe' common-updater-scripts "update-source-version"} "karabiner-dk" "$NEW_VERSION" --system=aarch64-darwin --ignore-same-version --version-key="sourceVersion";
  '';

  meta = {
    changelog = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/tag/${finalAttrs.src.tag}";
    description = "Virtual keyboard and virtual mouse using DriverKit on macOS";
    homepage = "https://karabiner-elements.pqrs.org/";
    maintainers = with lib.maintainers; [ auscyber ];
    license = lib.licenses.unlicense;
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
