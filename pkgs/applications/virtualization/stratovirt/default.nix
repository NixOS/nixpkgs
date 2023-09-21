{ lib, rustPlatform, fetchgit
, pkg-config, pixman, libcap_ng, cyrus_sasl
, libpulseaudio, libclang, gtk3, libusbgx, alsa-lib
, linuxHeaders, libseccomp
}:

rustPlatform.buildRustPackage rec {
  pname = "stratovirt";
  version = "2.2.0";

  src = fetchgit {
    url = "https://gitee.com/openeuler/stratovirt.git";
    rev = "v${version}";
    sha256 = "sha256-K99CmaBrJu30/12FxnsNsDKsTyX4f2uQSO7cwHsPuDw=";
  };
  patches = [ ./micro_vm-allow-SYS_clock_gettime.patch ];

  cargoSha256 = "sha256-SFIOGGRzGkVWHIXkviVWuhDN29pa0uD3GqKh+G421xI=";

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
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
