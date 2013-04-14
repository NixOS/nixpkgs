{ stdenv, fetchurl, makeWrapper, cmake, unzip, curl, amdappsdk }:

stdenv.mkDerivation rec {
  version = "v13beta4";
  name = "reaper-${version}";

  src = fetchurl {
    url = "http://zerosignalgame.com/reaper${version}_src.zip";
    sha256  = "1l42n3y9wb4manay35k7p3fn3ybiid3dhf0q2wdq7fxp63498ypk";
  };

  buildInputs = [ stdenv makeWrapper cmake unzip curl amdappsdk ];
  #configureScript = "./autogen.sh";
  #configureFlags = "--enable-scrypt";
  NIX_LDFLAGS = "-lgcc_s";

  sourceRoot = ".";

  #preConfigure = ''
  #  ln -s ${amdadlsdk}/include/* ADL_SDK/
  #'';

  #postBuild = ''
  #  gcc api-example.c -I compat/jansson -o cgminer-api
  #'';

  #postInstall = ''
  #  cp cgminer-api $out/bin/
  #  chmod 444 $out/bin/*.cl
  #'';

  installPhase = ''
    mkdir -p $out/bin
    cp reaper $out/bin
    wrapProgram "$out/bin/reaper" --prefix PATH ":" "${stdenv.gcc}/bin"
  '';

  meta = {
    description = "CPU/GPU miner in c for bitcoin";
    longDescription= ''
      This is a multi-threaded multi-pool GPU, FPGA and ASIC miner with ATI GPU
      monitoring, (over)clocking and fanspeed support for bitcoin and derivative
      coins. Do not use on multiple block chains at the same time!
    '';
    homepage = "https://github.com/ckolivas/cgminer";
    license = stdenv.lib.licenses.gpl3;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
