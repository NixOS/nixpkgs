{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitHub,
  pciutils,
  fwupd-efi,
  ipxe,
  refind,
  syslinux,
}:

assert lib.assertMsg stdenv.hostPlatform.isEfi "gnu-efi may only be built for EFI platforms";

stdenv.mkDerivation (finalAttrs: {
  pname = "gnu-efi";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "ncroxon";
    repo = "gnu-efi";
    tag = finalAttrs.version;
    hash = "sha256-oIj0aNY4xU5OcO69TTjh5FcWzzkFd6jbenwzVvTXjqo=";
  };

  buildInputs = [ pciutils ];

  hardeningDisable = [ "stackprotector" ];

  makeFlags = [
    "PREFIX=\${out}"
    "HOSTCC=${buildPackages.stdenv.cc.targetPrefix}cc"
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  postPatch = ''
    substituteInPlace Make.defaults \
      --replace "-Werror" ""
  '';

  passthru.tests = {
    inherit
      fwupd-efi
      syslinux
      ;
  };

  meta = {
    description = "GNU EFI development toolchain";
    homepage = "https://github.com/ncroxon/gnu-efi";
    license = with lib.licenses; [
      # This is a mess, upstream is aware.
      # The source for these is Fedora's SPDX identifier for this package.
      # Fedora also has gpl2Only here, but 4.0.2 doesn't have gpl2Only code.
      # However, both upstream and Fedora seems to have missed
      # bsdAxisNoDisclaimerUnmodified and MIT.
      bsd2
      bsd2Patent
      bsd3
      bsdAxisNoDisclaimerUnmodified
      bsdOriginal
      gpl2Plus
      mit
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ lzcunt ];
  };
})
