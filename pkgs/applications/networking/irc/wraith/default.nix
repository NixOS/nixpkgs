{ lib, stdenv, fetchurl, openssl }:

stdenv.mkDerivation rec {
  pname = "wraith";
  version = "1.4.10";
  src = fetchurl {
    url = "mirror://sourceforge/wraithbotpack/wraith-v${version}.tar.gz";
    sha256 = "1h8159g6wh1hi69cnhqkgwwwa95fa6z1zrzjl219mynbf6vjjzkw";
  };
  hardeningDisable = [ "format" ];
  buildInputs = [ openssl ];
  patches = [ ./configure.patch ./dlopen.patch ];
  postPatch = ''
    substituteInPlace configure        --subst-var-by openssl.dev ${openssl.dev} \
                                       --subst-var-by openssl-lib ${lib.getLib openssl}
    substituteInPlace src/libssl.cc    --subst-var-by openssl ${lib.getLib openssl}
    substituteInPlace src/libcrypto.cc --subst-var-by openssl ${lib.getLib openssl}
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp -a wraith $out/bin/wraith
    ln -s wraith $out/bin/hub
  '';

  meta = with lib; {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "IRC channel management bot written purely in C/C++";
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
    homepage = "https://wraith.botpack.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elitak ];
    platforms = platforms.linux;
  };
}
