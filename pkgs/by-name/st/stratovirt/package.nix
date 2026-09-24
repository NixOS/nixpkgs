{
  lib,
  rustPlatform,
  fetchgit,
  pkg-config,
  pixman,
  libcap_ng,
  cyrus_sasl,
  libpulseaudio,
  gtk3,
  libusbgx,
  alsa-lib,
  linuxHeaders,
  libseccomp,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stratovirt";
  version = "2.4.0";

  src = fetchgit {
    url = "https://gitee.com/openeuler/stratovirt.git";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1Ex6ahKBoVRikSqrgHGYaBFzWkPFDm8bGVyB7KmO8tI=";
  };

  cargoHash = "sha256-tNFF5WdQyNqkj2ahtpOfGTHriHpMGtV1UurO3teKFcU=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pixman
    libcap_ng
    cyrus_sasl
    libpulseaudio
    gtk3
    libusbgx
    alsa-lib
    linuxHeaders
    libseccomp
  ];

  meta = {
    homepage = "https://gitee.com/openeuler/stratovirt";
    description = "Virtual Machine Manager from Huawei";
    license = lib.licenses.mulan-psl2;
    maintainers = with lib.maintainers; [ astro ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "stratovirt";
  };
})
