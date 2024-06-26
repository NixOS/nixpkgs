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
  version = "2.3.0";

  src = fetchgit {
    url = "https://gitee.com/openeuler/stratovirt.git";
    rev = "v${version}";
    sha256 = "sha256-f5710f7Lz7ul1DYrC0CAfDR+7e1NrE9ESPdB8nlVUKw=";
  };
  patches = [ ./micro_vm-allow-SYS_clock_gettime.patch ];

  cargoSha256 = "sha256-prs7zkPAKQ99gjW7gy+4+CgEgGhaTTCLPTbLk/ZHdts=";

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
