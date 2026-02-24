{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  fetchpatch,
  ldns,
  libck,
  nghttp2,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "dnsperf";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "DNS-OARC";
    repo = "dnsperf";
    rev = "v${version}";
    hash = "sha256-eDDVNFMjj+0wEBe1qO6r4Bai554Sp+EmP86reJ/VXGk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ldns # optional for DDNS (but cheap anyway)
    libck
    nghttp2
    openssl
  ];

  patches = lib.optionals stdenv.hostPlatform.isMusl [
    # dnsperf doesn't have support for musl (https://github.com/DNS-OARC/dnsperf/issues/265)
    # and strerror_r returns int on non-glibc: https://github.com/NixOS/nixpkgs/issues/370498
    # TODO: remove if better non-glibc detection is ever upstreamed
    (fetchpatch {
      url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/5bd92b8f86a0bf15dddf8fa180adf14344d6cc15/testing/dnsperf/musl-perf_strerror_r.patch";
      hash = "sha256-yTJHXkti/xSklmVfAV45lEsOiHy7oL1phImNTNtcPkM=";
    })
  ];

  doCheck = true;

  meta = {
    description = "Tools for DNS benchmaring";
    homepage = "https://www.dns-oarc.net/tools/dnsperf";
    changelog = "https://github.com/DNS-OARC/dnsperf/releases/tag/v${version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    mainProgram = "dnsperf";
    maintainers = with lib.maintainers; [
      vcunat
      mfrw
    ];
  };
}
