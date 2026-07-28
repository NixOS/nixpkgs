{
  lib,
  writeTextFile,
  mesa,
}:
writeTextFile {
  name = "dri-pkgconfig-stub";

  # Version intentionally hardcoded to avoid rebuilds on Mesa updates.
  # If anything ever requires a newer version, this can simply be bumped manually.
  text = ''
    dridriverdir=${mesa.driverLink}/lib/dri

    Name: dri
    Version: 25.0
    Description: Nixpkgs graphics driver path stub
  '';

  destination = "/lib/pkgconfig/dri.pc";

  meta.badPlatforms = lib.platforms.darwin;
}
