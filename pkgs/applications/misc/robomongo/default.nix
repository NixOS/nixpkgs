{ stdenv, fetchurl, qt5, openssl, boost, cmake, scons, python, pcre }:

stdenv.mkDerivation {
  name = "robomongo-0.8.4-rc2";

  src = fetchurl {
    url = https://github.com/paralect/robomongo/archive/v0.8.4-rc2.tar.gz;
    sha256 = "0pgq9vbxikq0k7rdcs9j7pz8y46br0x1vv9ag1lw4fhl0k4p4slg";
  };

  patches = [ ./robomongo.patch ];
  
  NIX_CFLAGS_COMPILE = "-fno-stack-protector";

  buildInputs = [ cmake boost scons qt5 openssl python pcre ];

  buildPhase = ''
    cd ..
    mkdir target
    cd target
    cmake ..
    make
    make install
  '';

  installPhase = ''
    mkdir -p $out
    rm ./install/bin/robomongo.sh
    cp -R ./install/* $out
  '';
  
  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/robomongo):${openssl}/lib:${stdenv.gcc.gcc}/lib:$out/lib" $out/bin/robomongo
  '';

  meta = {
    homepage = "http://robomongo.org/";
    description = "query GUI for mongodb";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.amorsillo ];
  };
}
