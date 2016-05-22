{stdenv, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison, makeWrapper}:

stdenv.mkDerivation rec {
  version = "2.9.8.2";
  name = "snort-${version}";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://snort.org/downloads/archive/snort/${name}.tar.gz";
    sha256 = "0cwk02jan0vw6r3jl3vrf31vfp7i4c1r4yhb42h4gyhd6lnh2xa0";
  };
  
  buildInputs = [ makeWrapper libpcap pcre libdnet daq zlib flex bison ];

  enableParallelBuilding = true;

  configureFlags = "--disable-static-daq --enable-control-socket --with-daq-includes=${daq}/includes --with-daq-libraries=${daq}/lib"; 

  postInstall = ''
    wrapProgram $out/bin/snort --add-flags "--daq-dir ${daq}/lib/daq --dynamic-preprocessor-lib-dir $out/lib/snort_dynamicpreprocessor/ --dynamic-engine-lib-dir $out/lib/snort_dynamicengine"
  '';
  
  meta = {
    description = "Network intrusion prevention and detection system (IDS/IPS)";
    homepage = http://www.snort.org;
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    license = stdenv.lib.licenses.gpl2;
  };
}
