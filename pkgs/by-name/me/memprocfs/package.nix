{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  fuse2,
  lz4,
  leechcore,
  openssl,
  python3,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "memprocfs";
  version = "5.19";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ufrisk";
    repo = "MemProcFS";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xWsG01fYu/2hbNwW8dZ3+KIVGTmEF2xmQRRqZjJzs8c=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libusb1
    fuse2
    lz4
    leechcore
    openssl
    python3
  ];

  postPatch = ''
    substituteInPlace vmm/Makefile \
      --replace-fail "../files/leechcore.so" "${leechcore}/lib/leechcore.so"
    substituteInPlace memprocfs/Makefile \
      --replace-fail "../files/leechcore.so" "${leechcore}/lib/leechcore.so"
  '';

  buildPhase = ''
    runHook preBuild
    make -C vmm
    make -C memprocfs
    make -C m_vmemd
    make -C vmmpyc
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 files/leechcore.so -t "$out/lib"

    install -Dm755 files/vmm.so -t "$out/lib"
    install -Dm644 vmm/vmm.h -t "$out/include"
    install -Dm755 files/memprocfs -t "$out/bin"

    install -Dm755 files/plugins/m_vmemd.so -t "$out/lib/plugins"

    install -Dm755 files/vmmpyc.so -t "$out/lib"
    install -Dm644 vmmpyc/vmmpyc.h -t "$out/include"
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Browse and analyze physical memory through a virtual file system";
    homepage = "https://github.com/ufrisk/MemProcFS/";
    changelog = "https://github.com/ufrisk/MemProcFS/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
    mainProgram = "memprocfs";
  };
})
