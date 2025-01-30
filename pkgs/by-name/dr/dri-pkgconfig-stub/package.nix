{
  lib,
  writeTextFile,
  mesa,
}:
writeTextFile {
  name = "dri-pkgconfig-stub";

  text = ''
    dridriverdir=${mesa.driverLink}/lib/dri

    Name: dri
    Version: ${mesa.version}
    Description: Nixpkgs graphics driver path stub
  '';

  destination = "/lib/pkgconfig/dri.pc";

  meta.badPlatforms = lib.platforms.darwin;
}
