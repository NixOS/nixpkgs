{ stdenv, lib, fetchurl, dpkg, patchelf, qt4, libXtst, libXext, libX11, makeWrapper, libXScrnSaver }:

let
  src =
    if stdenv.system == "i686-linux" then fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_current_i386.deb";
      sha256 = "1wi9ikwmc9jfilj8adad3rcb7rmmxkpkfcp2gkfxvdyw6n0mzcnf";
    } else fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_current_amd64.deb";
      sha256 = "074yivz7rz1ac1962dix0aahpyqvsrkizh32kk5hyw5az0vqpcjs";
    };

in

stdenv.mkDerivation {
  # https://www.rescuetime.com/updates/linux_release_notes.html
  name = "rescuetime-2.9.10.1255";
  inherit src;
  buildInputs = [ dpkg makeWrapper ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp usr/bin/rescuetime $out/bin

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/bin/rescuetime

    wrapProgram $out/bin/rescuetime \
      --prefix LD_PRELOAD : ${qt4}/lib/libQtGui.so.4:${qt4}/lib/libQtCore.so.4:${libXtst}/lib/libXtst.so.6:${libXext}/lib/libXext.so.6:${libX11}/lib/libX11.so.6:${libXScrnSaver}/lib/libXss.so.1
  '';
  meta = with lib; {
    description = "Helps you understand your daily habits so you can focus and be more productive";
    homepage    = "https://www.rescuetime.com";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.unfree;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
