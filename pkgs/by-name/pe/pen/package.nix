{
  stdenv,
  lib,
  fetchzip,
  geoip,
  openssl,
  cacert,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pen";
  version = "0.34.1";

  src = fetchzip {
    url = "https://siag.nu/pub/pen/pen-${finalAttrs.version}.tar.gz";
    hash = "sha256-XNHUUGPv0Tf04pLKQo5j4W0XegP8KOiwdyyr8fko6vs=";
  };

  buildInputs = [
    geoip
    openssl
  ];

  configureFlags = [
    "--with-ssl=${cacert}/etc/ssl"
    "--with-geoip"
    "--prefix=${placeholder "out"}"
  ];

  meta = {
    license = lib.licenses.gpl2Plus;
    homepage = "http://siag.nu/pen";
    downloadPage = "https://siag.nu/pub/pen/";
    changelog = "https://github.com/UlricE/pen/blob/master/ChangeLog";
    mainProgram = "pen";
    platforms = lib.platforms.unix;
    description = "Load balancer for UDP and TCP-based protocols";
    longDescription = ''
      This is pen, a load balancer for udp and tcp based protocols such as
      dns, http or smtp. It allows several servers to appear as one to the
      outside and automatically detects servers that are down and distributes
      clients among the available servers. This gives high availability and
      scalable performance.
    '';
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
  };
})
