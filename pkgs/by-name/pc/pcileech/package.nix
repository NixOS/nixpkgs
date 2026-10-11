{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  fuse2,
  openssl,
  lz4,
  leechcore,
  memprocfs,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pcileech";
  version = "4.20";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ufrisk";
    repo = "pcileech";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2F/Qoh5BU9obosM6VOKnkRJwktMGDaP8N87FI2OvZ8s=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libusb1
    fuse2
    openssl
    lz4
    leechcore
    memprocfs
  ];

  postPatch = ''
    substituteInPlace pcileech/Makefile \
      --replace-fail "../files/vmm.so" "${memprocfs}/lib/vmm.so" \
      --replace-fail "../files/leechcore.so" "${leechcore}/lib/leechcore.so"
  '';

  makeFlags = [
    "-C"
    "pcileech"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 files/pcileech -t "$out/bin"
    install -Dm755 files/vmm.so -t "$out/lib"
    install -Dm755 files/leechcore.so -t "$out/lib"
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = [
    "info"
    "-help"
  ];

  meta = {
    description = "Direct Memory Access (DMA) Attack Software";
    homepage = "https://github.com/ufrisk/pcileech/";
    changelog = "https://github.com/ufrisk/pcileech/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "pcileech";
  };
})
