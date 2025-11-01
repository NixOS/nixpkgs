{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qrtr";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "qrtr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cPd7bd+S2uVILrFF797FwumPWBOJFDI4NvtoZ9HiWKM=";
  };

  nativeBuildInputs = [ meson ];

  buildInputs = [
    ninja
    pkg-config
  ];

  mesonFlags = [
    # The user space QRTR nameservice is not required because
    # there is a kernel space driver since Linux v5.7-rc1.
    (lib.mesonEnable "qrtr-ns" false)
    (lib.mesonEnable "systemd-service" false)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Userspace reference for net/qrtr in the Linux kernel";
    homepage = "https://github.com/linux-msm/qrtr";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "qrtr-cfg";
  };
})
