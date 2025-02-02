{ stdenv, lib, fetchurl, dpkg, patchelf, qt5, libXtst, libXext, libX11, mkDerivation, libXScrnSaver, writeScript, common-updater-scripts, curl, pup }:

let
  version = "2.16.5.1";
  src =
    if stdenv.hostPlatform.system == "i686-linux" then fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_${version}_i386.deb";
      sha256 = "1xrvyy0higc1fbc8ascpaszvg2bl6x0a35bzmdq6dkay48hnrd8b";
    } else fetchurl {
      name = "rescuetime-installer.deb";
      url = "https://www.rescuetime.com/installers/rescuetime_${version}_amd64.deb";
      sha256 = "09ng0yal66d533vzfv27k9l2va03rqbqmsni43qi3hgx7w9wx5ii";
    };
in mkDerivation rec {
  # https://www.rescuetime.com/updates/linux_release_notes.html
  inherit version;
  pname = "rescuetime";
  inherit src;
  nativeBuildInputs = [ dpkg ];
  # avoid https://github.com/NixOS/patchelf/issues/99
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp usr/bin/rescuetime $out/bin

    ${patchelf}/bin/patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath [ qt5.qtbase libXtst libXext libX11 libXScrnSaver ]}" \
      $out/bin/rescuetime
  '';

  passthru.updateScript = writeScript "${pname}-updater" ''
    #!${stdenv.shell}
    set -eu -o pipefail
    PATH=${lib.makeBinPath [curl pup common-updater-scripts]}:$PATH
    latestVersion="$(curl -sS https://www.rescuetime.com/release-notes/linux | pup '.release:first-of-type h2 strong text{}' | tr -d '\n')"

    for platform in ${lib.concatStringsSep " " meta.platforms}; do
      update-source-version ${pname} "$latestVersion" --system=$platform --ignore-same-version
    done
  '';

  meta = with lib; {
    description = "Helps you understand your daily habits so you can focus and be more productive";
    homepage    = "https://www.rescuetime.com";
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license     = licenses.unfree;
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}
