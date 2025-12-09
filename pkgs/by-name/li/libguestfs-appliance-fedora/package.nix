{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libguestfs-appliance-fedora";
  version = "1.56.0";

  src = fetchurl {
    url = "http://download.libguestfs.org/binaries/appliance/appliance-${version}.tar.xz";
    hash = "sha256-YbJlNaogMyutdtc7d+etyJvdd//yE8tedsZfkGXJr54=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp README.fixed initrd kernel root $out

    runHook postInstall
  '';

  meta = {
    description = "Fedora-based upstream VM appliance disk image used in libguestfs package";
    homepage = "https://libguestfs.org";
    license = lib.licenses.free;
    maintainers = with lib.maintainers; [ lukts30 ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    hydraPlatforms = [ ]; # Hydra fails with "Output limit exceeded"
  };
}
