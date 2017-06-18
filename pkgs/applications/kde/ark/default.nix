{
  mkDerivation, lib, config, makeWrapper,

  extra-cmake-modules, kdoctools,

  karchive, kconfig, kcrash, kdbusaddons, ki18n, kiconthemes, kitemmodels,
  khtml, kio, kparts, kpty, kservice, kwidgetsaddons, libarchive,

  # Archive tools
  p7zip, unzipNLS, zip,

  # Unfree tools
  unfreeEnableUnrar ? false, unrar,
}:

mkDerivation {
  name = "ark";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];
  propagatedBuildInputs = [
    karchive kconfig kcrash kdbusaddons khtml ki18n kiconthemes kio kitemmodels
    kparts kpty kservice kwidgetsaddons libarchive
  ];
  outputs = [ "out" "dev" ];
  postFixup =
    let
      PATH =
        lib.makeBinPath
        ([ p7zip unzipNLS zip ] ++ lib.optional unfreeEnableUnrar unrar);
    in ''
      wrapProgram "$out/bin/ark" --prefix PATH: "${PATH}"
    '';
  meta = {
    license = with lib.licenses;
      [ gpl2 lgpl3 ] ++ lib.optional unfreeEnableUnrar unfree;
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
