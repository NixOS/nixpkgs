{ stdenv, lib, fetchurl, dpkg, patchelf, qt4, libXtst, libXext, libX11, makeWrapper, libXScrnSaver }:

let
  src =
    if stdenv.system == "i686-linux" then fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_current_i386.deb";
      sha256 = "0nkbi05pr5kznj4vjqhsrxcqdmjdf2zsbirslxgm4jbh87skl6fm";
    } else fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_current_amd64.deb";
      sha256 = "161f71kvcrilv9qxldwn8xsqs2g9c2f2g9wb5brbfc0lqbbc8n89";
    };

in

stdenv.mkDerivation {
  # https://www.rescuetime.com/updates/linux_release_notes.html
  name = "rescuetime-2.9.11.1285";
  inherit src;
  buildInputs = [ dpkg makeWrapper ];
  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';
  installPhase = let

    lib = p: stdenv.lib.makeLibraryPath [ p ];

  in ''
    mkdir -p $out/bin
    cp usr/bin/rescuetime $out/bin

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_BINUTILS/nix-support/dynamic-linker)" \
      $out/bin/rescuetime

    wrapProgram $out/bin/rescuetime \
      --prefix LD_PRELOAD : ${lib qt4}/libQtGui.so.4:${lib qt4}/libQtCore.so.4:${lib libXtst}/libXtst.so.6:${lib libXext}/libXext.so.6:${lib libX11}/libX11.so.6:${lib libXScrnSaver}/libXss.so.1
  '';
  meta = with lib; {
    description = "Helps you understand your daily habits so you can focus and be more productive";
    homepage    = "https://www.rescuetime.com";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.unfree;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
