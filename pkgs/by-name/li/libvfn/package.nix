{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  perl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvfn";
  version = "5.1.0";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "SamsungDS";
    repo = "libvfn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CEVjJVeDEEJcJX2/6fwKGBHDsxgN+pL7fJWvQ+iCh3Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    perl
  ];

  postPatch = ''
    patchShebangs scripts/trace.pl scripts/ctags.sh scripts/sparse.py
  '';

  mesonFlags = [
    (lib.mesonEnable "docs" false)
    (lib.mesonEnable "libnvme" false)
    (lib.mesonBool "profiling" false)
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zero-dependency library for interacting with PCIe-based NVMe devices from user-space";
    longDescription = ''
      libvfn is a zero-dependency library for interacting with PCIe-based NVMe
      devices from user-space using the Linux kernel vfio-pci driver. The core
      of the library is excessively low-level and aims to allow controller
      verification and testing teams to interact with the NVMe device at the
      register and queue level.
    '';
    homepage = "https://github.com/SamsungDS/libvfn";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ joelgranados ];

    # Explicit list of tested platforms. The abstractions on other platforms
    # are untested and might not work. More will be added as we test them.
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
  };
})
