{ stdenv, lib, requireFile, demo, fetchurl, libX11, libXext, libXcursor, libXrandr, libjack2, alsaLib, ... }:

stdenv.mkDerivation rec {
  name = "renoise";

  buildInputs = [ libX11 libXext libXcursor libXrandr alsaLib libjack2 ];

  src =
    if stdenv.system == "x86_64-linux" then
        if demo then
        fetchurl {
            url = "http://files.renoise.com/demo/Renoise_3_0_1_Demo_x86_64.tar.bz2";
            sha256 = "1q7f94wz2dbz659kpp53a3n1qyndsk0pkb29lxdff4pc3ddqwykg";
        }
        else
        requireFile {
            url = "http://backstage.renoise.com/frontend/app/index.html#/login";
            name = "rns_3_0_1_linux_x86_64.tar.gz";
            sha256 = "1yb5w5jrg9dk9fg5rfvfk6p0rxn4r4i32vxp2l9lzhbs02pv15wd";
        }
    else if stdenv.system == "i686-linux" then
        if demo then
        fetchurl {
            url = "http://files.renoise.com/demo/Renoise_3_0_1_Demo_x86.tar.bz2";
            sha256 = "0dgqvib4xh2yhgh2wajj11wsb6xiiwgfkhyz32g8vnyaij5q8f58";
        }
        else
        requireFile {
            url = "http://backstage.renoise.com/frontend/app/index.html#/login";
            name = "rns_3_0_1_reg_x86.tar.gz";
            sha256 = "1swax2jz0gswdpzz8alwjfd8rhigc2yfspj7p8wvdvylqrf7n8q7";
        }
    else throw "platform is not suppored by Renoise";

  installPhase = ''
    cp -r Resources $out

    mkdir -p $out/lib/

    mv $out/AudioPluginServer* $out/lib/

    cp renoise $out/renoise

    for path in ${toString buildInputs}; do
      ln -s $path/lib/*.so* $out/lib/
    done

    ln -s ${stdenv.cc.cc}/lib/libstdc++.so.6 $out/lib/

    mkdir $out/bin
    ln -s $out/renoise $out/bin/renoise

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/lib $out/renoise
  '';

  meta = {
    description = "modern tracker-based DAW";
    homepage = http://www.renoise.com/;
    license = stdenv.lib.licenses.unfree;
  };
}
