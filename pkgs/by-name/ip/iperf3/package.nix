{
  lib,
  stdenv,
  fetchurl,
  openssl,
  fetchpatch,
  lksctp-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iperf";
  version = "3.21";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://downloads.es.net/pub/iperf/iperf-${finalAttrs.version}.tar.gz";
    hash = "sha256-ZW5EBevWIBId587KPq9DqI956huFfQQaagsTFIAazdg=";
  };

  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isLinux [ lksctp-tools ];
  configureFlags = [ "--with-openssl=${openssl.dev}" ];

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  patches = lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/main/iperf3/remove-pg-flags.patch?id=7f979fc51ae31d5c695d8481ba84a4afc5080efb";
      name = "remove-pg-flags.patch";
      hash = "sha256-cT3etRWaNRQrw7Gz4oTp6L5SJdKI/lrDywhYelzVf3w=";
    })
  ];

  postInstall = ''
    ln -s $out/bin/iperf3 $out/bin/iperf
    ln -s $man/share/man/man1/iperf3.1 $man/share/man/man1/iperf.1
  '';

  meta = {
    homepage = "https://software.es.net/iperf/";
    description = "Tool to measure IP bandwidth using UDP or TCP";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    mainProgram = "iperf3";
    maintainers = with lib.maintainers; [ fpletz ];
  };
})
