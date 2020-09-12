{ stdenv, lib, fetchurl, dpkg, patchelf, qt5, libXtst, libXext, libX11, mkDerivation, makeWrapper, libXScrnSaver }:

let
  version = "2.16.4.2";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_${version}_i386.deb";
      sha256 = "0zyal9n3rfj8i13v1q25inq6qyil7897483cdhqvwpb8wskrij4c";
    } else fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_${version}_amd64.deb";
      sha256 = "03bmnkxhip1wilnfqs8akmy1hppahxrmnm8gasnmw5s922vn06cv";
    };
in mkDerivation {
  # https://www.rescuetime.com/updates/linux_release_notes.html
  inherit version;
  pname = "rescuetime";
  inherit src;
  nativeBuildInputs = [ dpkg ];
  # avoid https://github.com/NixOS/patchelf/issues/99
  dontStrip = true;
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
      --set-rpath "${lib.makeLibraryPath [ qt5.qtbase libXtst libXext libX11 libXScrnSaver ]}" \
      $out/bin/rescuetime
  '';
  meta = with lib; {
    description = "Helps you understand your daily habits so you can focus and be more productive";
    homepage    = "https://www.rescuetime.com";
    maintainers = with maintainers; [ cstrahan ];
    license     = licenses.unfree;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
