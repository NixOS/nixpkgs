{ stdenv, lib, fetchurl, dpkg, patchelf, qt5, libXtst, libXext, libX11, mkDerivation, makeWrapper, libXScrnSaver }:

let
  src =
    if stdenv.hostPlatform.system == "i686-linux" then fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_current_i386.deb";
      sha256 = "1yzbs2lg04bq0clkr6gfkx3j6wrahpnxqfiq4askk9k76y4ncd4m";
    } else fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_current_amd64.deb";
      sha256 = "1njxsh601d0p6n0hxv44gcg8gd43xwym83xwqba26vj6xw82bknv";
    };
in mkDerivation {
  # https://www.rescuetime.com/updates/linux_release_notes.html
  name = "rescuetime-2.15.0.1";
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
