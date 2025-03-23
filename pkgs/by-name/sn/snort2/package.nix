{
  lib,
  stdenv,
  pkg-config,
  luajit,
  openssl,
  fetchurl,
  libpcap,
  pcre,
  libdnet,
  daq,
  zlib,
  flex,
  bison,
  makeWrapper,
  libtirpc,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.9.20";
  pname = "snort2";

  # TODO: remove this package after 25.05 release
  # https://github.com/NixOS/nixpkgs/pull/381363#issuecomment-2653483597
  src = fetchurl rec {
    name = "snort-${finalAttrs.version}.tar.gz";
    url = "https://snort.org/downloads/snort/${name}";
    sha256 = "sha256-KUAOE/U7GDHguLEOwSJKHLqm3BUzpTIqIN2Au4S0mBw=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    luajit
    openssl
    libpcap
    pcre
    libdnet
    daq
    zlib
    flex
    bison
    libtirpc
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];

  enableParallelBuilding = true;

  configureFlags = [
    "--disable-static-daq"
    "--enable-control-socket"
    "--with-daq-includes=${daq}/includes"
    "--with-daq-libraries=${daq}/lib"
  ];

  postInstall = ''
    wrapProgram $out/bin/snort --add-flags "--daq-dir ${daq}/lib/daq --dynamic-preprocessor-lib-dir $out/lib/snort_dynamicpreprocessor/ --dynamic-engine-lib-dir $out/lib/snort_dynamicengine"
  '';

  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = "https://www.snort.org";
    maintainers = with lib.maintainers; [ aycanirican ];
    license = lib.licenses.gpl2;
    platforms = with lib.platforms; linux;
  };
})
