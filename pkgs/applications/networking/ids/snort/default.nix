{stdenv, pkgconfig, luajit, openssl, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison, makeWrapper
, libtirpc
}:

stdenv.mkDerivation rec {
  version = "2.9.16.1";
  pname = "snort";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "https://snort.org/downloads/archive/snort/${pname}-${version}.tar.gz";
    sha256 = "13lzvjli6kbsnkd7lf0rm71l2mnz38pxk76ia9yrjb6clfhlbb73";
  };

  buildInputs = [ makeWrapper pkgconfig luajit openssl libpcap pcre libdnet daq zlib flex bison libtirpc ];

  NIX_CFLAGS_COMPILE = [ "-I${libtirpc.dev}/include/tirpc" ];

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
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
    platforms = with stdenv.lib.platforms; linux;
  };
}
