{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  pkg-config,
  libfprint-tod,
  gusb,
  udev,
  nss,
  openssl,
  meson,
  pixman,
  ninja,
  glib,
}:
stdenv.mkDerivation {
  pname = "libfprint-2-tod1-vfs0090";
  version = "0.8.5";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "3v1n0";
    repo = "libfprint-tod-vfs0090";
    rev = "6084a1545589beec0c741200b18b0902cca225ba";
    sha256 = "sha256-tSML/8USd/LuHF/YGLvNgykixF6VYtfE4SXzeV47840=";
  };

  patches = [
    # TODO remove once https://gitlab.freedesktop.org/3v1n0/libfprint-tod-vfs0090/-/merge_requests/1 is merged
    ./0001-vfs0090-add-missing-explicit-dependencies-in-meson.b.patch
    # TODO remove once https://gitlab.freedesktop.org/3v1n0/libfprint-tod-vfs0090/-/merge_requests/2 is merged
    ./0002-vfs0090-add-missing-linux-limits.h-include.patch
    # Fix build against libfprint-tod >= 1.94: fpi_ssm_next_state_delayed
    # lost its GCancellable argument
    (fetchpatch {
      url = "https://github.com/speed785/validity-vfs0090-linux-driver/commit/c97588da41e431716987fe07a662530869d4dd24.patch";
      hash = "sha256-AJQOHoRRZF3zloSKWVgibVBBxXJajU0rSgNhlzgOS5A=";
    })
    # Compute the TLS record HMAC via OpenSSL instead of NSS PK11:
    # PK11_GetBestSlot can return NULL on current systems, crashing fprintd
    # during verification
    (fetchpatch {
      url = "https://github.com/speed785/validity-vfs0090-linux-driver/commit/c047812b9356829c958ce9a3b717a3e6f27893cc.patch";
      hash = "sha256-Xs/bu+Jp1XZOocVxDpUx8p40I4Az8+XueP5PAtwiwZY=";
      excludes = [ "README.md" ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  # Note: mainline libfprint must NOT be in buildInputs. Both it and
  # libfprint-tod install include/libfprint-2/fp-device.h, but their
  # FpDeviceType enums are ordered differently (mainline inserted
  # FP_DEVICE_TYPE_UDEV before _USB in 1.94). Compiled against the mainline
  # header, the driver loads but is silently skipped during device matching
  # because cls->type does not equal libfprint-tod's FP_DEVICE_TYPE_USB.
  buildInputs = [
    libfprint-tod
    glib
    gusb
    udev
    nss
    openssl
    pixman
  ];

  installPhase = ''
    runHook preInstall

    install -D -t "$out/lib/libfprint-2/tod-1/" libfprint-tod-vfs009x.so
    install -D -t "$out/lib/udev/rules.d/" $src/60-libfprint-2-tod-vfs0090.rules

    runHook postInstall
  '';

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = {
    description = "Libfprint-2-tod Touch OEM Driver for 2016 ThinkPad's fingerprint readers";
    homepage = "https://gitlab.freedesktop.org/3v1n0/libfprint-tod-vfs0090";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ valodim ];
  };
}
