{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  bpftools,
  lib,
  nspr,
  libpcap,
  clang,
  fd,
  go-bindata,
  glibc,
  gnutls,
  bashInteractive,
  postgresql,
  mariadb,
  openssl,
  bash,
  zsh,
  nix-update-script,
}:

buildGoModule rec {
  pname = "ecapture";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "gojue";
    repo = "ecapture";
    tag = "v${version}";
    hash = "sha256-JqFb58JAepyNuxR3YVUX0tB+V66JrLVPUIVrnZn1aHw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    clang
    fd
    bpftools
    go-bindata
  ];

  newlibpcap = libpcap.overrideAttrs (previousAttrs: {
    configureFlags = previousAttrs.configureFlags ++ [ "--without-libnl" ];
  });

  buildInputs = [
    newlibpcap
    glibc.static
    glibc
  ];

  CGO_LDFLAGS = "-lpcap -lpthread -static";

  ldflags = [
    "-extldflags '-static'"
    "-linkmode=external"
  ];

  hardeningDisable = [
    "zerocallusedregs"
  ];

  postPatch = ''
    substituteInPlace user/config/config_gnutls_linux.go \
      --replace-fail 'return errors.New("cant found Gnutls so load path")' 'gc.Gnutls = "${lib.getLib gnutls}/lib/libgnutls.so.30"' \
      --replace-fail '"errors"' ' '

    substituteInPlace user/module/probe_bash.go \
      --replace-fail '/bin/bash' '${lib.getExe bashInteractive}'

    substituteInPlace user/config/config_bash.go \
      --replace-fail '/bin/bash' '${lib.getExe bashInteractive}'

    substituteInPlace user/config/config_nspr_linux.go \
      --replace-fail '/usr/lib/firefox/libnspr4.so' '${lib.getLib nspr}/lib/libnspr4.so'

    substituteInPlace user/config/config_zsh.go \
      --replace-fail '/bin/zsh' '${lib.getExe zsh}'

    substituteInPlace user/module/probe_zsh.go \
      --replace-fail '/bin/zsh' '${lib.getExe zsh}'

    substituteInPlace cli/cmd/postgres.go \
      --replace-fail '/usr/bin/postgres' '${postgresql}/bin/postgres'

    substituteInPlace cli/cmd/mysqld.go \
      --replace-fail '/usr/sbin/mariadbd' '${mariadb}/bin/mariadbd'

    substituteInPlace user/module/probe_mysqld.go \
      --replace-fail '/usr/sbin/mariadbd' '${mariadb}/bin/mariadbd'

    substituteInPlace user/config/config_openssl_linux.go \
      --replace-fail 'return errors.New("cant found openssl so load path")' 'oc.Openssl = "${lib.getLib openssl}/lib/libssl.so.3"' \
      --replace-fail '"errors"' ' '
  '';

  postConfigure = ''
    sed -i '/git/d' Makefile
    sed -i '/git/d' variables.mk

    substituteInPlace Makefile \
      --replace-fail '/bin/bash' '${lib.getExe bash}'

    make ebpf
    go-bindata -pkg assets -o "assets/ebpf_probe.go" $(find user/bytecode -name "*.o" -printf "./%p ")
  '';

  checkFlags =
    let
      skippedTests = [
        "TestCheckLatest"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  vendorHash = "sha256-KRW5Gf9LYwo5AZ9bYPht+4staiYVyWGkbX/sXDNDppc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Capture SSL/TLS text content without CA certificate Using eBPF";
    changelog = "https://github.com/gojue/ecapture/releases/tag/v${version}";
    homepage = "https://ecapture.cc";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "ecapture";
  };
}
