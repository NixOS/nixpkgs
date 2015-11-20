{stdenv, fetchurl, libpcap, pcre, libdnet, daq, zlib, flex, bison, makeWrapper}:

stdenv.mkDerivation rec {
  version = "2.9.7.2";
  name = "snort-${version}";
  
  src = fetchurl {
    name = "${name}.tar.gz";
    url = "mirror://sourceforge/snort/${name}.tar.gz";
    sha256 = "1gmlrh9ygpd5h6nnrr4090wk5n2yq2yrvwi7q6xbm6lxj4rcamyv";
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
