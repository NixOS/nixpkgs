{
  lib,
  rustPlatform,
  fetchgit,
  pkg-config,
  pixman,
  libcap_ng,
  cyrus_sasl,
  libpulseaudio,
  libclang,
  gtk3,
  libusbgx,
  alsa-lib,
  linuxHeaders,
  libseccomp,
}:

rustPlatform.buildRustPackage rec {
  pname = "stratovirt";
  version = "2.4.0";

  src = fetchgit {
    url = "https://gitee.com/openeuler/stratovirt.git";
    rev = "v${version}";
    hash = "sha256-1Ex6ahKBoVRikSqrgHGYaBFzWkPFDm8bGVyB7KmO8tI=";
  };

  cargoHash = "sha256-uuZCbmt3eIlKurwMOV7LezVSjOVG/90OdT2PC8YLi3I=";

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
    libclang
    linuxHeaders
    libseccomp
  ];

  meta = with lib; {
    homepage = "https://gitee.com/openeuler/stratovirt";
    description = "Virtual Machine Manager from Huawei";
    license = licenses.mulan-psl2;
    maintainers = with maintainers; [ astro ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "stratovirt";
  };
}
