{ stdenv, fetchurl, openssl }:

with stdenv;
with stdenv.lib;

mkDerivation rec {
  pname = "wraith";
  version = "1.4.7";
  src = fetchurl {
    url = "mirror://sourceforge/wraithbotpack/wraith-v${version}.tar.gz";
    sha256 = "0h6liac5y7im0jfm2sj18mibvib7d1l727fjs82irsjj1v9kif3j";
  };
  hardeningDisable = [ "format" ];
  buildInputs = [ openssl ];
  patches = [ ./configure.patch ./dlopen.patch ];
  postPatch = ''
    substituteInPlace configure        --subst-var-by openssl.dev ${openssl.dev} \
                                       --subst-var-by openssl.out ${openssl.out}
    substituteInPlace src/libssl.cc    --subst-var-by openssl ${openssl.out}
    substituteInPlace src/libcrypto.cc --subst-var-by openssl ${openssl.out}
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp -a wraith $out/bin/wraith
    ln -s wraith $out/bin/hub
  '';

  meta = {
    description = "An IRC channel management bot written purely in C/C++";
    longDescription = ''
      Wraith is an IRC channel management bot written purely in C/C++. It has
      been in development since late 2003. It is based on Eggdrop 1.6.12 but has
      since evolved into something much different at its core. TCL and loadable
      modules are currently not supported.

      Maintainer's Notes:
      Copy the binary out of the store before running it with the -C option to
      configure it. See https://github.com/wraith/wraith/wiki/GettingStarted .

      The binary will not run when moved onto non-NixOS systems; use patchelf
      to fix its runtime dependenices.
    '';
    homepage = https://wraith.botpack.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elitak ];
    platforms = platforms.linux;
  };
}
