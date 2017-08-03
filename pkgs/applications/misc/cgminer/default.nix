{ fetchgit, stdenv, pkgconfig, libtool, autoconf, automake
, curl, ncurses, amdappsdk, amdadlsdk, xorg, jansson }:

stdenv.mkDerivation rec {
  version = "3.7.2";
  name = "cgminer-${version}";

  src = fetchgit {
    url = "https://github.com/ckolivas/cgminer.git";
    rev = "refs/tags/v3.7.2";
    sha256  = "1xfzx91dpwjj1vmhas3v9ybs0p2i74lrhinijmpav15acfggm9fq";
  };

  buildInputs = [
    autoconf automake pkgconfig libtool curl ncurses amdappsdk amdadlsdk
    xorg.libX11 xorg.libXext xorg.libXinerama jansson
  ];
  configureScript = "./autogen.sh";
  configureFlags = "--enable-scrypt --enable-opencl";
  NIX_LDFLAGS = "-lgcc_s -lX11 -lXext -lXinerama";

  preConfigure = ''
    ln -s ${amdadlsdk}/include/* ADL_SDK/
  '';

  postBuild = ''
    gcc api-example.c -o cgminer-api
  '';

  postInstall = ''
    cp cgminer-api $out/bin/
    chmod 444 $out/bin/*.cl
  '';

  meta = with stdenv.lib; {
    description = "CPU/GPU miner in c for bitcoin";
    longDescription= ''
      This is a multi-threaded multi-pool GPU, FPGA and ASIC miner with ATI GPU
      monitoring, (over)clocking and fanspeed support for bitcoin and derivative
      coins. Do not use on multiple block chains at the same time!
    '';
    homepage = https://github.com/ckolivas/cgminer;
    license = licenses.gpl3;
    maintainers = [ maintainers.offline ];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
