{ stdenv, fetchurl, dpkg, openssl, alsaLib, libXext, libXfixes, libXrandr
, libjpeg, curl, libX11, libXmu, libXv, libXtst, qt4, mesa, zlib
, gnome, libidn, rtmpdump, c-ares, openldap, makeWrapper, cacert
}:
let
  curl_custom =
    stdenv.lib.overrideDerivation curl (args: { 
      configureFlags = args.configureFlags ++ ["--with-ca-bundle=${cacert}/etc/ca-bundle.crt"] ; 
    } );
in
stdenv.mkDerivation {
  name = "fuze-1.0.5";
  src = fetchurl {
    url = http://apt.fuzebox.com/apt/pool/lucid/main/f/fuzelinuxclient/fuzelinuxclient_1.0.5.lucid_amd64.deb;
    sha256 = "0gvxc8qj526cigr1lif8vdn1aawj621camkc8kvps23r7zijhnqv";
  };
  buildInputs = [ dpkg makeWrapper ];
  libPath =
    stdenv.lib.makeLibraryPath [
      openssl alsaLib libXext libXfixes libXrandr libjpeg curl_custom
      libX11 libXmu libXv qt4 libXtst mesa stdenv.gcc.gcc zlib
      gnome.GConf libidn rtmpdump c-ares openldap
    ];
  buildCommand = ''
    dpkg-deb -x $src .
    mkdir -p $out/lib $out/bin
    cp -R usr/lib/fuzebox $out/lib

    patchelf \
      --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
      --set-rpath $out/lib/fuzebox:$libPath \
      $out/lib/fuzebox/FuzeLinuxApp

    wrapProgram $out/lib/fuzebox/FuzeLinuxApp --prefix LD_LIBRARY_PATH : $libPath
    for f in $out/lib/fuzebox/*.so.*; do
      patchelf \
        --set-rpath $out/lib/fuzebox:$libPath \
        $f
    done

    ln -s ${openssl}/lib/libssl.so.1.0.0 $out/lib/fuzebox/libssl.so.0.9.8
    ln -s ${openssl}/lib/libcrypto.so.1.0.0 $out/lib/fuzebox/libcrypto.so.0.9.8

    ln -s $out/lib/fuzebox/FuzeLinuxApp $out/bin/fuze
  '';

  meta = {
    description = "Fuze for Linux";
    homepage = http://www.fuzebox.com;
    license = "unknown";
  };
}
