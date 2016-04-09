{ stdenv, fetchurl, openssl }:

with stdenv;
with stdenv.lib;

mkDerivation rec {
  name = "wraith-${version}";
  version = "1.4.6";
  src = fetchurl {
    url = "mirror://sourceforge/wraithbotpack/wraith-v${version}.tar.gz";
    sha256 = "0vb2hbjmwh040f5yhxvwcfxvgxa0q9zdy9vvddydn8zn782d7wl8";
  };
  buildInputs = [ openssl ];
  patches = [ ./dlopen.patch ];
  postPatch = ''
    substituteInPlace src/libssl.cc    --subst-var-by openssl ${openssl}
    substituteInPlace src/libcrypto.cc --subst-var-by openssl ${openssl}
  '';
  configureFlags = "--with-openssl=${openssl}";
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
    homepage = http://wraith.botpack.net/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elitak ];
    platforms = platforms.linux;
  };
}
