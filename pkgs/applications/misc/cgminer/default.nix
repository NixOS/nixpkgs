{ fetchgit, stdenv, pkgconfig, libtool, autoconf, automake,
  curl, ncurses, amdappsdk, amdadlsdk, xorg }:

stdenv.mkDerivation rec {
  version = "2.11.4";
  name = "cgminer-${version}";

  src = fetchgit {
    url = "https://github.com/ckolivas/cgminer.git";
    rev = "96c8ff5f10f2d8f0cf4d1bd889e8eeac2e4aa715";
    sha256  = "1vf9agy4vw50cap03qig2y65hdrsdy7cknkzyagv89w5xb230r9a";
  };

  buildInputs = [ autoconf automake pkgconfig libtool curl ncurses amdappsdk amdadlsdk xorg.libX11 xorg.libXext xorg.libXinerama ];
  configureScript = "./autogen.sh";
  configureFlags = "--enable-scrypt";
  NIX_LDFLAGS = "-lgcc_s -lX11 -lXext -lXinerama";

  preConfigure = ''
    ln -s ${amdadlsdk}/include/* ADL_SDK/
  '';

  postBuild = ''
    gcc api-example.c -I compat/jansson -o cgminer-api
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
    homepage = "https://github.com/ckolivas/cgminer";
    license = licenses.gpl3;
    maintainers = [ maintainers.offline ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
